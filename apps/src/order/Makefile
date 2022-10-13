run:
	sudo docker build -t octank-order:latest ./
	aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin xyz.dkr.ecr.us-east-1.amazonaws.com/octank-order
	sudo docker tag octank-order:latest xyz.dkr.ecr.us-east-1.amazonaws.com/octank-order:latest
	sudo docker push xyz.dkr.ecr.us-east-1.amazonaws.com/octank-order:latest
