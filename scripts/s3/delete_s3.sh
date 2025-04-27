#!/bin/env bash

# Get the most recently created bucket name
S3_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets | sort_by(@, &CreationDate)[-1].Name" --output text)

if [ -z "$S3_BUCKET_NAME" ]; then
    echo "No buckets found to delete."
    exit 1
fi

# Confirm the bucket name
echo "Deleting the most recently created S3 bucket: $S3_BUCKET_NAME"

# Delete all objects in the bucket (required before deleting the bucket)
echo "Deleting all objects in the bucket..."
aws s3 rm "s3://$S3_BUCKET_NAME" --recursive

# Delete the bucket
echo "Deleting the bucket..."
aws s3api delete-bucket --bucket "$S3_BUCKET_NAME"

# Confirm the bucket was deleted
echo "Listing all S3 buckets to confirm deletion:"
aws s3 ls