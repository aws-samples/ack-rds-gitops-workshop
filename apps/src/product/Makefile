run:
	sudo docker build -t octank-product:latest ./
	aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin xyz.dkr.ecr.us-east-1.amazonaws.com/octank-product
	sudo docker tag octank-product:latest xyz.dkr.ecr.us-east-1.amazonaws.com/octank-product:latest
	sudo docker push xyz.dkr.ecr.us-east-1.amazonaws.com/octank-product:latest
