# DAT312: Implement GitOps and manage your Amazon RDS resources using ACK from K8s

In this workshop, learn to deploy a continuous integration and delivery (CI/CD) workflow using GitOps and the AWS Controllers for Kubernetes (ACK) service controller for Amazon RDS on Amazon EKS to create and manage Amazon Aurora Serverless v2 databases effectively. GitOps relies on Git as the single source of truth for declaratively managing containerized infrastructure and application components. With Git at the center of CI/CD pipelines, developers can automate and simplify application deployments and operations to Kubernetes. You must bring your laptop to participate.

## Getting started

For this example we assume a scenario with two clusters: dev and production. The end goal is to leverage Flux and Kustomize to manage both clusters while minimizing duplicated declarations.

We will configure Flux to install, set up Amazon Aurora Serverless v2, Amazon MemoryDB for Redis and a retail application using [Flux Source Controllers](https://fluxcd.io/flux/components/source/) [AWS CodeCommit](https://aws.amazon.com/codecommit/) source control [repository](https://fluxcd.io/flux/components/source/gitrepositories/), [Helm Repository](https://fluxcd.io/flux/components/source/helmrepositories/), and [Helm Charts](https://fluxcd.io/flux/components/source/helmcharts/) custom resources. Flux will monitor the AWS CodeCommit and Helm repository, and it will automatically upgrade the retail application components using CodeCommit releases, and Helm releases to their latest chart version based on semver ranges.

## Prerequisites

You will need a Kubernetes cluster version 1.23 or newer and kubectl version 1.23 or newer. This lab utilizes AWS managed services such as Amazon Aurora Serverless v2, Amazon MemoryDB for Redis, AWS CodeCommit, and the lab works only on AWS EKS Cluster.

Please follow the following steps in order to follow the guide:

1. Set up environment variables and verify IAM OpenID Connect (OIDC) provider for your cluster.

  ```
    export AWS_ACCOUNT_ID='<aws account id>'
    export AWS_REGION='<aws region>'
    export EKS_CLUSTER_NAME='<eks cluster name>'
    export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
    export VPCID=<vpc id> # VPC for setting up Aurora Serverless v2 and MemoryDB
    export SERVICE=rds
    export ACK_K8S_NAMESPACE=ack-system
    export ACK_SYSTEM_NAMESPACE=ack-system
    export RELEASE_VERSION=`curl -sL https://api.github.com/repos/aws-controllers-k8s/$SERVICE-controller/releases/latest | grep '"tag_name":' | cut -d'"' -f4`

    oidc_id=$(aws eks describe-cluster --name $EKS_CLUSTER_NAME --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
    aws iam list-open-id-connect-providers | grep $oidc_id

  ```

2. Create ECR repositories for retail application, build and publish container images to ECR.

  ```
    git clone https://github.com/aws-samples/eks-gitops-workshop.git
    cd eks-gitops-workshop/apps/src
    make
  ```
In order to follow the guide you'll need a GitHub account and a personal access token that can create repositories (check all permissions under repo).

3. Create secret for RDS. Please update the password in

  ```
     aws secretsmanager create-secret \
        --name dbCredential \
        --description "RDS DB username/password" \
        --secret-string "{\"dbuser\":\"<db username>\",\"password\":\"<db password>\"}"
  ```

4. Install ACK for RDS.

  ```
  aws ecr-public get-login-password --region $AWS_REGION | \
    helm registry login --username AWS --password-stdin public.ecr.aws

  helm install --create-namespace -n "${ACK_SYSTEM_NAMESPACE}" "ack-${SERVICE}-controller" \
    "oci://public.ecr.aws/aws-controllers-k8s/${SERVICE}-chart" --version="${RELEASE_VERSION}" \
    --set=aws.region="${AWS_REGION}" \
    --set=serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::${AWS_ACCOUNT_ID}:role/ack-${SERVICE}-controller
  ```

5. To allow for Flux to use an AWS CodeCommit git repository in your GitOps pipeline, we need IAM user with `AWSCodeCommitFullAccess` IAM policy attached.

  ```
  export AWS_IAM_GC_USER=<iam username>
  export AWS_IAM_GC_PASS=<iam user password>
  ```

## Prepare your AWS CodeCommit git repository for automation

The Git repository contains the following top-level directories:

apps contains manifest for retail application and databases to go along with it infrastructure contains infra tools such as the ACK controllers and Helm repository definitions clusters contains the Flux configuration per cluster

  ```
  ├── apps
  │    ├── production
  │    └── dev
  ├── infrastructure
  │    ├── ack
  │    └── sources
  └── clusters
    ├── production
    └── dev
   ```

6. Install Flux in your Amazon EKS Cluster.

  ```
  flux install

  flux create source git flux-system \
    --git-implementation=libgit2 \
    --url=https://git-codecommit.${AWS_REGION}.amazonaws.com/v1/repos/ack-rds-gitops-workshop \
    --branch=master \
    --username=${AWS_IAM_GC_USER} \
    --password=${AWS_IAM_GC_PASS} \
    --interval=1m

  flux create kustomization flux-system \
    --source=flux-system \
    --path="./clusters/production" \
    --prune=true \
    --interval=1m
  ```

7. Install the ACK for RDS and ACK for MemoryDB controllers.

  ```
    cd -
    aws codecommit create-repository --repository-name ack-rds-gitops-workshop \
      --repository-description "EKS GitOps RDS Workshop"
    git clone https://git-codecommit.${AWS_REGION}.amazonaws.com/v1/repos/ack-rds-gitops-workshop ack.codecommit
    cp -rp eks-gitops-workshop/* ack.codecommit/
    cd ack.codecommit
    sed -i -e "s/^#//g" infrastructure/production/sources/kustomization.yaml
    sed -i -e "s/^#//g" infrastructure/production/kustomization.yaml
    git commit -m "Add ACK for RDS + ACK for MemoryDB controllers to prod infrastructure"
    git push
  ```

8. You can monitor the status of Flux HelmRelease and Kustomization resources to ensure they are Ready, Active, and with the message Release reconciliation succeeded using the following command:

  ```
  flux get helmreleases --all-namespaces
  watch flux get kustomizations --all-namespaces
  ```

9. Now check to see that the both the controllers are installed in the cluster. You can do so with the following command:

  ```
  flux get helmreleases --all-namespaces
  kubectl get pod -n "${ACK_K8S_NAMESPACE}"
  ```

## Building a GitOps pipeline to deploy an app using Amazon RDS databases

10. Update application manifest, commit and push changes to CodeCommit repo.

  ```
  sed -i -e "s/^#//g" apps/production/kustomization.yaml
  git commit -m "Deploy retail app w/Amazon Aurora + Amazon MemoryDB"
  git push
  ```

11. Ensure that all of our requested resources are set up as we requested. We can do this with the following command:

  ```
  flux get kustomizations --all-namespaces
  kubectl get DBInstance ack-db-instance01 -n retailapp -o jsonpath='{range }{.status.dbInstanceStatus}{"\n"}{end}'
  kubectl get Cluster memorydb-cluster -n retailapp -o jsonpath='{range }{.status.status}{"\n"}{end}'
  kubectl get pod -n retailapp
  ```

12. Run the following bootstrap database once the database is in `available` state.

  ```
  RDSHOST=$(kubectl get dbinstance -n retailapp ack-db-instance01 --output json | jq '.status.endpoint.address' | sed -e 's/"//g')
  export PGPASSWORD=$(aws secretsmanager get-secret-value --secret-id dbCredential --query "SecretString" --output text | jq -r '.password')
  psql -h $RDSHOST -d postgres -U adminer -f apps/src/setup_schema.sql
  ```

13. Ensure that all Pods for retail application are in `Running` state.

  ```
  kubectl get pod -n retailapp
  ```

14. Get Ingress information for retail application.

  ```
  kubectl get ingress -n retailapp
  ```

15. Use web browser from  your work station and open the URL from above Ingress. Ensure that the application UI has loaded successfully.

## Ongoing management of AWS resources through a GitOps pipeline

16. Update the `minCapacity` & `MaxCapacity` values in `apps/production/aurora-pg.yaml` in CodeCommit repo and push changes.

  ```
  sed -i -e "s/minCapacity: .*$/minCapacity: 2/g" \
    -e "s/maxCapacity: .*$/maxCapacity: 8/g" \
    apps/production/aurora-pg.yaml

  git commit -a -m "Updating Min & Max ACU"
  git push
  ```

17. We can verify that these changes were successful in a few ways. First, look at the logs from the ACK for RDS controller pod.

  ```
  kubectl logs --selector k8s-app=rds-chart -n ack-system
  ```

18. Apply updates to retail application.

    ```
    sed -i -e "s/banner.png/banner-sale.jpg/g"  apps/src/webapp/app/general/templates/general/index.html
    ```

19. Build and publish new container image version.

    ```
    cd ~/environment/ack.codecommit/apps/src/
    aws ecr get-login-password --region ${AWS_REGION} | \
      docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
    docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/webapp:1.1 webapp/.
    docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/webapp:1.1
    ```

20. Update our application manifest to refer to the new application container image version.

  ```
  cd -
  sed -i -e "s/webapp:1.0/webapp:1.1/g" apps/production/retailapp/deployments.yaml
  git commit -a -m "Webapp container version 1.1"
  git push
  ```

21. Like our previous changes, Flux will detect that there is a new commit in the git repository. You can verify that the changes roll out using the command below.

  ```
  watch flux get kustomizations --all-namespaces
  ```

