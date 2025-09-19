# Terraform - EC2 + RDS + VPC (multi-file)
This repo contains Terraform code that provisions a VPC with public/private subnets, NACL, Security Groups, an EC2 instance (public) and an RDS MySQL instance (private).


## Recommended workflow (using Terraform Cloud)
1. Create a repository and push these files.
2. Create an organization and workspace in Terraform Cloud, connect the VCS repo to the workspace.
3. In the Terraform Cloud workspace SETTINGS > Variables add the following environment variables (sensitive):
- `AWS_ACCESS_KEY_ID` (env var)
- `AWS_SECRET_ACCESS_KEY` (env var)

And add Terraform variables (workspace variables):
- `key_name` (string)
- `db_password` (sensitive)


4. Queue a run in Terraform Cloud. Terraform Cloud will execute `plan` and `apply` remotely — you do not need AWS CLI or Terraform CLI locally for execution.


## Notes
- You must create an EC2 KeyPair named the same as `key_name` in the target AWS region, or import one.
- If you want to use a different AMI or region, change variables accordingly.
- Keep `db_password` secret — mark it sensitive in Terraform Cloud.