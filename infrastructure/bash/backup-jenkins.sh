# Create a back up of all jenkins file and then push it to s3
# Required aws-cli package to be already installed and have already set up aws credentials

#!/bin/bash

zip -r  jenkins-volume ~/simple-login/jenkins-volume
aws s3 cp jenkins-volume.zip "s3://intern-devops2/jenkins/$(date)"
