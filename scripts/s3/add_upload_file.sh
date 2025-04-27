#!/bin/env bash

# Get the most recently created bucket name
S3_BUCKET_NAME=$(aws s3api list-buckets --query "Buckets | sort_by(@, &CreationDate)[-1].Name" --output text)

if [ -z "$S3_BUCKET_NAME" ]; then
    echo "No buckets found to delete."
    exit 1
fi

FILE_PATH="./file.txt"

if [ -f "$FILE_PATH" ]; then
    echo "File exists: $FILE_PATH"
else
    echo "File does not exist. Creating file: $FILE_PATH"
    touch "$FILE_PATH"
    echo "This is a test file." > "$FILE_PATH"
    echo "File created: $FILE_PATH"
fi

# Upload the file to the S3 bucket
aws s3 cp "$FILE_PATH" "s3://$S3_BUCKET_NAME/${FILE_PATH##*/}"
if [ $? -eq 0 ]; then
    echo "File uploaded successfully to $S3_BUCKET_NAME/${FILE_PATH##*/}"
else
    echo "Failed to upload file to S3."
    exit 1
fi
# Confirm the file was uploaded
echo "Listing files in the S3 bucket:"
aws s3 ls "s3://$S3_BUCKET_NAME/"
if [ $? -eq 0 ]; then
    echo "File listing successful."
else
    echo "Failed to list files in S3 bucket."
    exit 1
fi
# Clean up the local file
rm "$FILE_PATH"
if [ $? -eq 0 ]; then
    echo "Local file deleted successfully."
else
    echo "Failed to delete local file."
    exit 1
fi


