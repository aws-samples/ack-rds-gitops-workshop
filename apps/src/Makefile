
run:
	AWS_REGION=$(shell curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
	AWS_ACCOUNT_ID=$(shell aws sts get-caller-identity --output text --query Account)
	docker build -t $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/eksack/webapp:1.0 webapp/.
	docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/product:1.0 product/.
	docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/kart:1.0 kart/.
	docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/order:1.0 order/.
	docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/user:1.0 user/.
	aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
	aws ecr create-repository --repository-name eksack/webapp
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/webapp:1.0
	aws ecr create-repository --repository-name eksack/product
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/product:1.0
	aws ecr create-repository --repository-name eksack/order
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/order:1.0
	aws ecr create-repository --repository-name eksack/kart
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/kart:1.0
	aws ecr create-repository --repository-name eksack/user
	docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/eksack/user:1.0

