# Demo Dev Stack Module #
## AWS ##
### Base Requirements ###
* SSH keys configured
* Terraform installed
* AWS CLI configured
### EC2 ###
This will spin up the necessary infrastructure to support EC2 instances.
It creates the following:
* Base VPC and Subnet
* Create a route for 0.0.0.0/0
* Security group with rules for ingress (22 from anywhere) and full egress
* Ubuntu 20.04 LTS hosts

### RDS ###
Spins up a t3.micro RDS instance

### S3 ###
Spins up a private S3 bucket

#### Using EC2 ####
1. Create the `terraform.tfvars` file inside of the EC2 directory
2. Run `terraform apply` to spin up the infrastructure

#### Environment Variables ####
The following environment variables need to be set to pass in AWS credentials
##### Terraform Cloud Environment Variable #####
```
TF_VAR_AWS_ACCESS_KEY_ID = <AWS Access Key ID>
TF_VAR_AWS_SECRET_ACCESS_KEY = <AWS Secret Access Key>
```

##### Local Environment Variable Commands #####
```
export TF_VAR_AWS_ACCESS_KEY_ID=<AWS Access Key ID>
export TF_VAR_AWS_SECRET_ACCESS_KEY=<AWS Secret Access Key>
```

#### main.auto.tfvars ####
Variables are as follows
```
prefix         = "<prefix for your resources>"
region         = "<aws region>"
cidr           = "<CIDR block>"
subnet         = "<subnet>"
key_pair_name  = "<name of your key pair>"
instance_count = "<number of EC2 instances you need want to spin up>"
```

### EKS ###
This will spin up an entire EKS cluster including all required underlying infrastructure