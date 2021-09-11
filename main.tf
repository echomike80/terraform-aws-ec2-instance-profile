resource "aws_iam_role" "ec2" {
  name  = format("rl-%s", var.name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudwatch_agent" {
  count = var.enable_cloudwatch_agent_policy ? 1 : 0
  name  = format("pol-%s-cloudwatch-agent-policy", var.name)

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    }
  ]
}
EOF
}

# This policy is an inline policy and the same as the managed policy AmazonSSMManagedInstanceCore
resource "aws_iam_policy" "ssm" {
  count = var.enable_ssm_policy ? 1 : 0
  name  = format("pol-%s-ssm-policy", var.name)

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "custom" {
  count  = length(var.custom_policy_jsons)
  name   = format("pol-%s-custom-policy-%s", var.name, count.index)
  path   = "/"
  policy = element(var.custom_policy_jsons, count.index)
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  count         = var.enable_cloudwatch_agent_policy ? 1 : 0
  role          = aws_iam_role.ec2.name
  policy_arn    = aws_iam_policy.cloudwatch_agent[0].arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count         = var.enable_ssm_policy ? 1 : 0
  role          = aws_iam_role.ec2.name
  policy_arn    = aws_iam_policy.ssm[0].arn
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = length(var.custom_policy_jsons)
  role       = aws_iam_role.ec2.name
  policy_arn = element(aws_iam_policy.custom.*.arn, count.index)
}

resource "aws_iam_instance_profile" "ec2" {
  name = format("ec2rl-%s", var.name)
  role = aws_iam_role.ec2.name
}