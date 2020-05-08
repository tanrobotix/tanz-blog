clean:
	gatsby clean
build:
	gatsby build
publish:
	scp -r public ubuntu@ec2-54-169-90-113.ap-southeast-1.compute.amazonaws.com:/data/
