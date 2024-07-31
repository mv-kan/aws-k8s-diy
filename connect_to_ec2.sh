#!/bin/bash

# Function to display usage message
usage() {
    echo "Usage: $0 <path_to_key> <ec2_instance_id>"
    echo "Example: $0 /path/to/key.pem i-1234567890abcdef0"
    exit 1
}

# Function to validate the EC2 instance ID format
validate_ec2_id() {
    if [[ ! $1 =~ ^i-[0-9a-f]{17}$ ]]; then
        echo "Error: Invalid EC2 Instance ID format."
        exit 1
    fi
}

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Error: Incorrect number of arguments."
    usage
fi

KEY_PATH=$1
EC2_ID=$2

# Check if the key file exists
if [ ! -f "$KEY_PATH" ]; then
    echo "Error: Key file not found at $KEY_PATH."
    exit 1
fi

# Validate EC2 instance ID
validate_ec2_id "$EC2_ID"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it and try again."
    exit 1
fi

# Check if ssh is installed
if ! command -v ssh &> /dev/null; then
    echo "Error: SSH is not installed. Please install it and try again."
    exit 1
fi

# Attempt to connect to the EC2 instance
echo "Attempting to connect to EC2 instance $EC2_ID using key $KEY_PATH..."

ssh -i $KEY_PATH admin@$EC2_ID \
    -o ProxyCommand="aws ec2-instance-connect open-tunnel --instance-id $EC2_ID"

# Check if the SSH connection was successful
if [ $? -eq 0 ]; then
    echo "Successfully connected to EC2 instance $EC2_ID."
else
    echo "Failed to connect to EC2 instance $EC2_ID. Please check your credentials and try again."
fi