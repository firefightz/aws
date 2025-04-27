#!/bin/env bash

# Define the bucket name and region
S3_BUCKET_NAME="firefightz-test-bucket-$(date +%Y%m%d%H%M%S)"
AWS_REGION="us-east-1"

# Create the S3 bucket
echo "Creating S3 bucket: $S3_BUCKET_NAME in region: $AWS_REGION"
if [ "$AWS_REGION" == "us-east-1" ]; then
    aws s3api create-bucket --bucket "$S3_BUCKET_NAME"
else
    aws s3api create-bucket --bucket "$S3_BUCKET_NAME" --region "$AWS_REGION" --create-bucket-configuration LocationConstraint="$AWS_REGION"
fi

# Confirm the bucket was created
echo "Listing all S3 buckets:"
aws s3 ls