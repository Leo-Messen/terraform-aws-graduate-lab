################################################################################
# Codebuild
################################################################################
data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AWSCodeBuildAdminAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}
resource "aws_iam_role" "codebuild_tf_deploy" {
  name               = "codebuild-${var.environment}-${var.project_name}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_ecs_deploy_codebuild" {
  role       = aws_iam_role.codebuild_tf_deploy.name
  policy_arn = data.aws_iam_policy.AWSCodeBuildAdminAccess.arn
}
