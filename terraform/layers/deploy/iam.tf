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

resource "aws_iam_role_policy_attachment" "codebuild_tf_deploy_attach_policy" {
  role       = aws_iam_role.codebuild_tf_deploy.name
  policy_arn = data.aws_iam_policy.AWSCodeBuildAdminAccess.arn
}
################################################################################
# Codepipeline
################################################################################
data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "AWSCodePipeline_FullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}
resource "aws_iam_role" "codepipeline_tf_deploy" {
  name               = "codepipeline-${var.environment}-${var.project_name}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codepipeline_tf_deploy_attach_policy" {
  role       = aws_iam_role.codepipeline_tf_deploy.name
  policy_arn = data.aws_iam_policy.AWSCodePipeline_FullAccess.arn
}
