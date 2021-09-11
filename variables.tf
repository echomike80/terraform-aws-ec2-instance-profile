variable "custom_policy_jsons" {
  description = "List of JSON strings of custom policies to be attached to the Instance Profile"
  type        = list(string)
  default     = []
}

# Example
# local.policy = <<EOF
# {
#    "Version": "2012-10-17",
#    "Statement": [{
#       "Effect": "Allow",
#       "Action": [
#          "ec2:DescribeInstances", 
#          "ec2:DescribeImages",
#          "ec2:DescribeTags", 
#          "ec2:DescribeSnapshots"
#       ],
#       "Resource": "*"
#    }
#    ]
# }
# EOF

variable "enable_cloudwatch_agent_policy" {
  description = "Enable cloudwatch agent policy permissions to the IAM Role for the Instance Profile"
  type        = bool
  default     = true
}

variable "enable_ssm_policy" {
  description = "Enable ssm policy permissions to the IAM Role for the Instance Profile"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}