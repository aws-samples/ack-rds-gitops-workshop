run:
	sudo docker build -t octank-user:latest ./
	aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-user
	sudo docker tag octank-user:latest <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-user:latest
	sudo docker push <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-user:latest

