run:
	sudo docker build -t octank-webapp:latest ./
	aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-webapp
	sudo docker tag octank-webapp:latest <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-webapp:latest
	sudo docker push <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-webapp:latest
