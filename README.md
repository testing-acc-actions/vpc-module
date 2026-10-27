# Terraform AWS VPC Project

This project uses Terraform to create a basic AWS Virtual Private Cloud (VPC) and its networking components. It’s a hands-on way to learn Infrastructure as Code (IaC) and understand how AWS networking works.

## What you’ll learn

- Create AWS networking resources using Terraform.
- Practice the Terraform workflow: `init`, `fmt`, `validate`, `plan`, and `apply`.
- Understand VPCs, public and private subnets, Internet Gateways, route tables, and subnet associations.
- Prepare your project for automated checks using GitHub Actions.
- Learn to review infrastructure changes before applying them.

## Architecture

The project is designed around the following configuration:

- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24` in `ap-south-1a`
- Private subnet: `10.0.11.0/24` in `ap-south-1a`
- Internet Gateway: Attached to the VPC.
- Public route table: Routes internet-bound traffic (`0.0.0.0/0`) through the Internet Gateway.
- Private route table: Associated with the private subnet, without a NAT Gateway or default internet route.

Keep in mind that naming a subnet “public” doesn’t automatically make it public. Its routing and network configuration determine how it can communicate. The private subnet in this project does not have outbound internet access through a NAT Gateway.

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/5e1714e0-a01c-4ccc-8c52-d09bc2dddca6" />

## Tools used

- AWS account and AWS CLI
- AWS IAM Identity Center (SSO)
- Terraform
- Git and GitHub
- GitHub Actions for CI checks

## Project structure

Your repository may look like this:

```
terraform-vpc-project/
├── main.tf
├── terraform.tf
├── outputs.tf
├── .gitignore
├── .terraform.lock.hcl
└── .github/
    └── workflows/
        └── terraform-check.yml
```

- `main.tf` contains the VPC, subnets, Internet Gateway, route tables, and associations.
- `terraform.tf` defines the required Terraform and provider configuration. If you use an S3 backend, its configuration belongs inside a `terraform` block.
- `outputs.tf` defines useful values, such as VPC and subnet IDs.
- `.terraform.lock.hcl` records provider version selections and should be committed to Git.
- `.gitignore` excludes local state files and generated files that shouldn’t be committed.
- `terraform-check.yml` defines automated Terraform checks in GitHub Actions.

## Prerequisites

Before starting, make sure you have:

1. Terraform installed.
2. AWS CLI installed.
3. An AWS account with the necessary permissions.
4. An AWS SSO profile configured for local development.
5. A dedicated private S3 bucket created beforehand if you plan to use an S3 backend.

For example, to authenticate using an SSO profile:

```
aws sso login --profile terraform-vpc
aws sts get-caller-identity --profile terraform-vpc --region ap-south-1
```

Replace `terraform-vpc` with your actual AWS CLI profile name.

For local development, Terraform can use your configured AWS profile. For GitHub Actions, use OpenID Connect (OIDC) to obtain temporary AWS credentials instead of storing long-lived access keys.

## Running the project

Open PowerShell in your project directory and run:

```
terraform fmt -recursive
terraform init
terraform validate
terraform plan
```

These commands format the configuration, initialize Terraform, check for configuration errors, and show the proposed infrastructure changes.

Once you’ve reviewed the plan and confirmed that it matches your expectations, run:

```
terraform apply
```

Always review the plan before applying changes. If you switch from local state to an S3 backend, migrate the existing state carefully rather than assuming Terraform will automatically track resources created previously.

## GitHub Actions and automation

GitHub Actions can automatically check formatting, initialize Terraform, and validate your configuration whenever you push changes or open a pull request.

As the project grows, you can introduce deployment workflows that use GitHub OIDC to assume a restricted AWS IAM role.

Recommended practices:

- Grant `id-token: write` only to workflows that need it.
- Restrict the OIDC trust policy to the intended repository and branch.
- Follow the principle of least privilege when granting AWS permissions.
- Require approval before applying changes to production environments.
- Never store long-lived AWS access keys in GitHub secrets.
- Avoid running `terraform apply` automatically on every pull request.

## Terraform state and security

Terraform state helps Terraform track the resources it manages. It can contain sensitive information, so protect it carefully.

- Keep state files private.
- Enable S3 bucket versioning if you use remote state.
- Consider S3 state locking with `use_lockfile = true` when supported by your Terraform version.
- Keep the state bucket separate from your application resources where practical.
- Never commit `terraform.tfstate`, credentials, secret variable files, or sensitive plan files.
- Remember that adding a file to `.gitignore` does not remove it from Git history if it was already committed.

## Cost considerations

The VPC, subnets, route tables, and Internet Gateway generally do not incur hourly charges on their own. However, related services can generate costs, including NAT Gateways, public IPv4 addresses, and data transfer.

This starter project does not include a NAT Gateway, which helps keep the setup simpler and avoids that particular hourly charge. Check current AWS pricing and remove resources you no longer need.

## Cleaning up resources

When you finish experimenting, review the destruction plan:

```
terraform plan -destroy
```

If the plan shows only resources dedicated to this project, you can remove them with:

```
terraform destroy
```

Do not run these commands if the Terraform state includes shared resources or if you are unsure what will be deleted.

## Current project status

This README documents the intended starter architecture. Before treating it as an exact description of your deployed environment, verify the Terraform configuration, outputs, backend, and AWS resources in your repository.

