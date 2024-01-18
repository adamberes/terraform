# Create AWS Infrastructure with Terraform VPC Public/Private Subnets Internet-gateway Security-groups EC2-Instances 

In this configuration, we will describe the possibility of creating more than one EC2 instance in a subnet.
## Introdution To Terraform
- VPC (Virtual Private Cloud)
- Public subnet and private subnet
- Internet Gateway
- Security Groups
- Key Pair

## Installation 
**Install aws cli (Command Line Interface)**
Install from the folowing Link:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
**Install Terraform**
 - **AWS Configuration File (`~/.aws/config`):**
  - The region used for executing Terraform commands is typically taken from the AWS configuration file (`~/.aws/config`). The region specified in the Terraform provider block (`us-east-1`) is a fallback in case it's not specified in the AWS configuration file.

- **AWS Credentials File (`~/.aws/credentials`):**
  - AWS credentials (access key and secret key) used by Terraform are stored in the AWS credentials file (`~/.aws/credentials`).
  - These credentials can be configured using the `aws configure` command, which interactively prompts you to enter your AWS access key, secret key, default region, and output format.

- Creating AWS User+
Log in to the `AWS Management Console`, navigate to `IAM`, and create a new user. Generate an access key for programmatic access; detailed steps are available in the accompanying video. Describing the `AWS Management Console` here is omitted as it is subject to continuous evolution and change

- Create a ssh key pair (ed25519) with pasphrase
```hcl
ssh-keygen -t ed25519 -C "your_email@example.com"
```



## main.tf

1. **Terraform Block:**
   - The `terraform` blocks in Terraform configuration files declare the required Terraform version and provider dependencies.

2. **Required Providers:**
   - The `required_providers` block specifies the required providers for the configuration. In this case, it's AWS (`hashicorp/aws`) with a version constraint of at least 5.31.

3. **Terraform Version Constraint:**
   - The `required_version` specifies the minimum Terraform version required to apply this configuration. Here, it's set to at least version 1.6.0.

4. **Provider Block (AWS):**
   - The `provider` blocks define the configuration for specific providers. In this case, it's the AWS provider.
   - The `region = "us-east-1"` specifies the AWS region where the resources will be provisioned. EC2 instances, for example, will be launched in the "us-east-1" region.


## variables.tf

The provided Terraform configuration defines several variables that are crucial for the setup of the infrastructure. Below is an explanation of each variable:

## IP Addresses for Web Servers (`ips_web`)
- **Type:** `map(string)` - Specifies that the variable is a map where the keys are strings and the values are strings.
- **Default Values:** A mapping of indices ("0" to "4") to corresponding IP addresses for web servers.

## Selected Amazon Machine Image (AMI) (`selected-ami`)

- **Description:** Provides a description for the variable.
- **Default Value:** Specifies the default Amazon Machine Image (AMI) to be used. In this case, it is set to "Ubuntu Server 22.04 LTS ubuntu".

## Mapping of AMI Names to AMI IDs (`map-ami-name-user`)

- **Type:** `map(string)` - Specifies that the variable is a map where the keys are strings, and the values are strings.
- **Default Values:** Maps human-readable AMI names to their corresponding AMI IDs for various operating systems.

These variables provide flexibility and ease of configuration when deploying infrastructure using Terraform. Adjustments can be made based on specific requirements or changes in infrastructure needs.

##output.tf
The provided Terraform configuration defines two outputs, which are used to provide information or results after the infrastructure deployment. Below is an explanation of each output:

## Public IPs of Web Servers (`public-ips-wb`)

- **Description:** This output provides the public IP addresses of the web servers.
- **Value:** Uses the `aws_instance.server.*.public_ip` expression to get a list of public IP addresses for all instances. The `join` function is then used to concatenate them into a comma-separated string.
- **Usage:** After running Terraform apply, you can retrieve the public IPs of the deployed instances by accessing the `public-ips-wb` output.

## Selected AMI with Name Information (`selected-ami-with-name`)

- **Description:** This output provides information about the selected AMI, including its name and ID.
- **Value:** Uses the `format` function to create a formatted string that includes the AMI name specified in `var.selected-ami` and its corresponding AMI ID obtained from `var.map-ami-name-user`.
- **Usage:** After running Terraform apply, you can retrieve information about the selected AMI by accessing the `selected-ami-with-name` output.

These outputs are helpful for obtaining critical information or summaries after deploying infrastructure using Terraform. They provide a way to programmatically retrieve specific details about the deployed resources.

## Control the created instance
In the output, there will be a list `public-ips-wb` of started EC2 Instances (depending on `aws_instance.server.count`) visible. On these IPs, it is possible to log in over SSH to the created EC2 server.

The output `selected-ami-with-name` indicates the installed AMI with the Description and username.

```hcl
public-ips-wb = [
  "52.90.45.63",
]
selected-ami-with-name = "ami-by-name: Ubuntu Server 22.04 LTS ubuntu; ami-id: ami-0c7217cdde317cfec"
```

To SSH into the server:

```hcl
ssh -i timbuktu.ppk ubuntu@52.90.45.63 -v
```
In the browser, under http://52.90.45.63, something similar is visible:

```hcl
Private Ip: ip-10-0-1-101
Creation Time: Thu Jan 18 19:37:47 UTC 2024
```

