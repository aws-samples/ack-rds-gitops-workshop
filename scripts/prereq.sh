#!/bin/sh

function print_line()
{
    echo "---------------------------------"
}

function install_packages()
{
    sudo yum install -y jq  > ${TERM} 2>&1
    print_line
    echo "Installing aws cli v2"
    print_line
    aws --version | grep aws-cli\/2 > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        cd $current_dir
	return
    fi
    current_dir=`pwd`
    cd /tmp
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > ${TERM} 2>&1
    unzip -o awscliv2.zip > ${TERM} 2>&1
    sudo ./aws/install --update > ${TERM} 2>&1
    cd $current_dir
}

function install_k8s_utilities()
{
    print_line
    echo "Installing Kubectl"
    print_line
    sudo curl -o /usr/local/bin/kubectl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  > ${TERM} 2>&1
    sudo chmod +x /usr/local/bin/kubectl > ${TERM} 2>&1
    print_line
    echo "Installing eksctl"
    print_line
    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp > ${TERM} 2>&1
    sudo mv /tmp/eksctl /usr/local/bin
    sudo chmod +x /usr/local/bin/eksctl
    print_line
    echo "Installing helm"
    print_line
    curl -s https://fluxcd.io/install.sh | sudo bash > ${TERM} 2>&1
    curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash > ${TERM} 2>&1

}

function install_postgresql()
{
    print_line
    echo "Installing Postgresql client"
    print_line
    sudo amazon-linux-extras install -y postgresql14 > ${TERM} 2>&1
}


function update_kubeconfig()
{
    print_line
    echo "Updating kubeconfig"
    print_line
    aws eks update-kubeconfig --name ${EKS_CLUSTER_NAME}
}


function update_eks()
{
    print_line
    echo "Enabling clusters to use iam oidc"
    print_line
    eksctl utils associate-iam-oidc-provider --cluster ${EKS_CLUSTER_NAME} --region ${AWS_REGION} --approve
}


function chk_installation()
{ 
    print_line
    echo "Checking the current installation"
    print_line
    for command in kubectl aws eksctl flux helm jq
    do
        which $command &>${TERM} && echo "$command present" || echo "$command NOT FOUND"
    done

}


function clone_git()
{
    print_line
    echo "Cloning the git repository"
    print_line
    cd ${HOME}/environment
    rm -rf ack.gitlab ack.codecommit
    #git clone https://github.com/aws-samples/ack-rds-gitops-workshop ack.gitlab
    git clone https://github.com/ajrajkumar/ack-rds-gitops-workshop ack.gitlab
    git clone https://git-codecommit.${AWS_REGION}.amazonaws.com/v1/repos/ack-rds-gitops-workshop ack.codecommit
    cd ack.codecommit
    cp -rp ../ack.gitlab/* .
    print_line
}

function fix_git()
{
    print_line
    echo "Fixing the git repository"
    print_line

    cd ${HOME}/environment/ack.codecommit

    # Update infrastructure manifests
    sed -i -e "s/<region>/$AWS_REGION/g" ./infrastructure/production/ack/*release*.yaml
    sed -i -e "s/<account_id>/$AWS_ACCOUNT_ID/g" ./infrastructure/production/ack/*serviceaccount.yaml

    # Update application manifests
    sed -i -e "s/<region>/$AWS_REGION/g" \
         -e "s/<account_id>/$AWS_ACCOUNT_ID/g" \
         -e "s/<dbSubnetGroupName>/rds-db-subnet/g" \
         -e "s/<MemdbSubnetGroupName>/memorydb-db-subnet/g" \
         -e "s/<vpcSecurityGroupIDs>/$VPCID/g" \
       ./apps/production/retailapp/*.yaml

    sed -i -e "s/<region>/$AWS_REGION/g" \
   	-e "s/<account_id>/$AWS_ACCOUNT_ID/g" \
   	-e "s/<dbSubnetGroupName>/rds-db-subnet/g" \
   	-e "s/<MemdbSubnetGroupName>/memorydb-db-subnet/g" \
   	-e "s/<vpcSecurityGroupIDs>/$vpcsg/g" \
   	./apps/production/*.yaml

    git add .
    git commit -a -m "Initial version"
    git push
}

function install_loadbalancer()
{

    print_line
    echo "Installing load balancer"
    print_line
    eksctl create iamserviceaccount \
     --cluster=${EKS_CLUSTER_NAME} \
     --namespace=${EKS_NAMESPACE} \
     --name=aws-load-balancer-controller \
     --attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
     --override-existing-serviceaccounts \
     --approve

    helm repo add eks https://aws.github.io/eks-charts

    kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

    helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
     --set clusterName=${EKS_CLUSTER_NAME} \
     --set serviceAccount.create=false \
     --set region=${AWS_REGION} \
     --set vpcId=${VPCID} \
     --set serviceAccount.name=aws-load-balancer-controller \
     -n ${EKS_NAMESPACE}

}


function chk_aws_environment()
{
    print_line
    echo "Checking AWS environment"
    print_line
    for myenv in "${AWS_DEFAULT_REGION}" "${AWS_ACCESS_KEY_ID}" "${AWS_SECRET_ACCESS_KEY}" "${AWS_SESSION_TOKEN}"
    do
        if [ x"${myenv}" == "x" ] ; then
            echo "AWS environment is missing. Please import from event engine"
	    exit
	fi
    done
    echo "AWS environment exists"
    
}


function run_kubectl()
{
    print_line
    echo "kubectl get nodes -o wide"
    print_line
    kubectl get nodes -o wide
    print_line
    echo "kubectl get pods --all-namespaces"
    print_line
    kubectl get pods --all-namespaces
}

function create_iam_user()
{
    print_line
    echo "Creating AWS IAM User for git"
    print_line
    aws iam create-user --user-name gituser
    if [[ $? -ne 0 ]]; then
      echo "ERROR: Failed to create user"
    fi
    print_line
    aws iam attach-user-policy --user-name gituser \
      --policy-arn arn:aws:iam::aws:policy/AWSCodeCommitFullAccess
    if [[ $? -ne 0 ]]; then
      echo "ERROR: Failed to attach plicy to user"
    fi
    print_line
}

function build_and_publish_container_images()
{
    print_line
    echo "Create docker container images for application and publish to ECR"
    cd ~/environment/ack.codecommit/apps/src
    export TERM=xterm
    make
    cd -
    print_line
}

function create_secret()
{
    print_line
    aws secretsmanager create-secret     --name dbCredential     --description "RDS DB username/password"     --secret-string "{\"dbuser\":\"adminer\",\"password\":\"postgres\"}" 
    print_line
}

function install_c9()
{
    print_line
    npm install -g c9
    print_line
}

function chk_cloud9_permission()
{
    aws sts get-caller-identity | grep ${INSTANCE_ROLE}  
    if [ $? -ne 0 ] ; then
	echo "Fixing the cloud9 permission"
        environment_id=`aws ec2 describe-instances --instance-id $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --query "Reservations[*].Instances[*].Tags[?Key=='aws:cloud9:environment'].Value" --output text`
        aws cloud9 update-environment --environment-id ${environment_id} --region ${AWS_REGION} --managed-credentials-action DISABLE
	sleep 10
        ls -l $HOME/.aws/credentials > /dev/null 2>&1
        if [ $? -eq 0 ] ; then
             echo "!!! Credentials file exists"
        else
            echo "Credentials file does not exists"
        fi
	echo "After fixing the credentials. Current role"
        aws sts get-caller-identity | grep ${INSTANCE_ROLE}
    fi
}


function initial_cloud9_permission()
{
    print_line
    echo "Checking initial cloud9 permission"
    typeset -i counter=0
    managed_role="FALSE"
    while [ ${counter} -lt 2 ] 
    do
        aws sts get-caller-identity | grep ${INSTANCE_ROLE}  
        if [ $? -eq 0 ] ; then
            echo "Called identity is Instance role .. Waiting - ${counter}"
	    sleep 30
	    counter=$counter+1
	else
	    echo "Called identity is AWS Managed Role .. breaking"
	    managed_role="TRUE"
	    break
	fi
    done

    if [ ${managed_role} == "TRUE" ] ;  then
        echo "Current role is AWS managed role"
    else
        echo "Current role is Instance role.. May cause issue later deployment. But still continuing"
    fi

    chk_cloud9_permission
}


function print_environment()
{
    print_line
    echo "Current Region : ${AWS_REGION}"
    echo "EKS Namespace  : ${EKS_NAMESPACE}"
    echo "EKS Cluster Name : ${EKS_CLUSTER_NAME}"
    echo "VPCID           : ${VPCID}"
    echo "VPC SG           : ${vpcsg}"
    print_line
}

# Main program starts here

export INSTANCE_ROLE="C9Role"

if [ ${1}X == "-xX" ] ; then
    TERM="/dev/tty"
else
    TERM="/dev/null"
fi

echo "Process started at `date`"
install_packages

export AWS_REGION=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r`
initial_cloud9_permission
export EKS_NAMESPACE="kube-system"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text) 
export VPCID=$(aws cloudformation describe-stacks --region $AWS_REGION --query 'Stacks[].Outputs[?OutputKey == `VPC`].OutputValue' --output text)
 
install_k8s_utilities
install_postgresql
#create_iam_user
clone_git
chk_cloud9_permission
export EKS_CLUSTER_NAME=$(aws cloudformation describe-stacks --query "Stacks[].Outputs[?(OutputKey == 'EKSClusterName')][].{OutputValue:OutputValue}" --output text)
export vpcsg=$(aws ec2 describe-security-groups --filters Name=ip-permission.from-port,Values=5432 Name=ip-permission.to-port,Values=5432 --query "SecurityGroups[0].GroupId" --output text)
print_environment
fix_git
update_kubeconfig
chk_cloud9_permission
update_eks
chk_cloud9_permission
install_loadbalancer
chk_installation
chk_cloud9_permission
run_kubectl
chk_cloud9_permission
build_and_publish_container_images
create_secret
print_line
install_c9
print_line

echo "Process completed at `date`"
