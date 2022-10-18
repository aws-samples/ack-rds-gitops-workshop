run:
	sudo docker build -t octank-kart:latest ./
	aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-kart
	sudo docker tag octank-kart:latest <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-kart:latest
	sudo docker push <acct-number>.dkr.ecr.us-east-1.amazonaws.com/octank-kart:latest
