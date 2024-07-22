create terraform.tfvars here like this 
```
allowed_account_ids = ["1111111111111"]

name = "dev-vpc"

cidr = "10.20.0.0/16"

azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]

public_subnets = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]

public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAXDDQfyj9eJvm/pIHrVKcR/u/eKICo3Zs1QUPK7dlhMF1N aws stuff"
```