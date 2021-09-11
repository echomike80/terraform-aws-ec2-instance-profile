# AWS EC2 instance profile Terraform module

Terraform module which creates am EC2 instance profile with its IAM role and policies on AWS.

## Terraform versions

Terraform 0.12 and newer. 

## Usage

```hcl

locals {
  instance_profile_custom_policy_1  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
                "route53:ListHostedZones",
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

module "ec2_instance_profile" {
  source    = "/path/to/terraform-aws-ec2-instance-profile"
  name      = var.name

  custom_policy_jsons               = [local.instance_profile_custom_policy_1]
  enable_cloudwatch_agent_policy    = true
  enable_ssm_policy                 = true
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.65 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.65 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.cloudwatch_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_policy_jsons"></a> [custom\_policy\_jsons](#input\_custom\_policy\_jsons) | List of JSON strings of custom policies to be attached to the Instance Profile | `list(string)` | `[]` | no |
| <a name="input_enable_cloudwatch_agent_policy"></a> [enable\_cloudwatch\_agent\_policy](#input\_enable\_cloudwatch\_agent\_policy) | Enable cloudwatch agent policy permissions to the IAM Role for the Instance Profile | `bool` | `true` | no |
| <a name="input_enable_ssm_policy"></a> [enable\_ssm\_policy](#input\_enable\_ssm\_policy) | Enable ssm policy permissions to the IAM Role for the Instance Profile | `bool` | `true` | no |   
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_profile_id"></a> [instance\_profile\_id](#output\_instance\_profile\_id) | ID of Instance Profile used to reference the created objects in aws\_instance resources |

## Authors

Module managed by [Marcel Emmert](https://github.com/echomike80).

## License

Apache 2 Licensed. See LICENSE for full details.
