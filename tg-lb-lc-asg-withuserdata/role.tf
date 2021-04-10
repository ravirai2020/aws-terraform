resource "aws_iam_role" "ecs_role"{
  name = var.ECS_ROLE_FOR_EC2
  assume_role_policy = file("policy/assume_role_policy.json")
}

resource "aws_iam_policy" "ecs_policy"{
  policy = file("policy/policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_role_attach"{
  role = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

resource "aws_iam_instance_profile" "role-instance-profile"{
  name = var.ECS_ROLE_FOR_EC2
  role = aws_iam_role.ecs_role.name
}

output "role"{
  value = aws_iam_role.ecs_role.arn
}

output "role_policy"{
  value = aws_iam_policy.ecs_policy.policy
}

output "instance_profile"{
  value = aws_iam_instance_profile.role-instance-profile.arn
}
