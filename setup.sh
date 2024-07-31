echo "==setup all terraform variables"

# Assign input arguments to variables
ACCOUNT_ID=$1
PUBLIC_KEY_PATH=$2
CLUSTER_NAME=$3
NAME=${4:-dev-vpc}

# Read the public key file content
if [ -f "$PUBLIC_KEY_PATH" ]; then
  PUBLIC_KEY=$(cat "$PUBLIC_KEY_PATH")
else
  echo "Error: Public key file not found at path $PUBLIC_KEY_PATH"
  exit 1
fi

# Check if any of the required variables are empty
if [ -z "$ACCOUNT_ID" ]; then
  echo "Error: ACCOUNT_ID is not provided."
  exit 1
fi

if [ -z "$PUBLIC_KEY" ]; then
  echo "Error: PUBLIC_KEY is empty or not readable."
  exit 1
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Error: CLUSTER_NAME is not provided."
  exit 1
fi

# Write the terraform.tfvars file
cat <<EOF | tee ./env/dev/terraform.tfvars
allowed_account_ids = ["$ACCOUNT_ID"]

name = "$NAME"

cidr = "10.20.0.0/16"

azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]

private_subnets = ["10.20.101.0/24"]
public_subnets = ["10.20.102.0/24"]

public_key = "$PUBLIC_KEY"

cluster_name = "$CLUSTER_NAME"
EOF

echo "Terraform variables setup completed."
