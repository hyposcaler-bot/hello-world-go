#!/bin/bash

set -e

echo "=== Checking AWS CLI availability ==="
which aws
aws --version

echo -e "\n=== Testing AWS credentials ==="
echo "Testing AWS credentials..."
aws sts get-caller-identity
echo "AWS credentials are working!"

echo -e "\n=== Testing basic AWS operations ==="
echo "Testing basic AWS operations..."
# List S3 buckets (if you have any)
aws s3 ls || echo "No S3 access or no buckets"

echo -e "\n=== Testing S3 download ==="
echo "Testing S3 download..."
# Replace with your actual bucket name and file path
BUCKET_NAME="clab-integration"
FILE_KEY="srl02-s3.clab.yml"
LOCAL_FILE="srl02-s3.clab.yml"

aws s3 cp s3://${BUCKET_NAME}/${FILE_KEY} ${LOCAL_FILE}

echo "File downloaded successfully:"
ls -la ${LOCAL_FILE}
echo "File contents:"
cat ${LOCAL_FILE}