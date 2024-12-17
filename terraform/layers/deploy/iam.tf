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

data "aws_iam_policy_document" "codebuild_tf_deploy" {
  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      aws_codebuild_project.github_tf_deploy_base.arn
    ]
  }
}

resource "aws_iam_role" "codebuild_tf_deploy" {
  name               = "codebuild-${var.environment}-${var.project_name}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role_policy" "codebuild_tf_deploy_attach_policy" {
  role   = aws_iam_role.codebuild_tf_deploy.name
  policy = data.aws_iam_policy_document.codebuild_tf_deploy.json
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

data "aws_iam_policy_document" "codepipeline_tf_deploy" {
  statement {
    effect = "Allow"

    actions = [
      "codestar-connections:UseConnection"
    ]

    resources = [
      aws_codestarconnections_connection.github_connection.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*",
    ]

    resources = [
      aws_s3_bucket.codepipeline_tf_deploy.arn,
      "${aws_s3_bucket.codepipeline_tf_deploy.arn}/*",
    ]
  }
}

resource "aws_iam_role" "codepipeline_tf_deploy" {
  name               = "codepipeline-${var.environment}-${var.project_name}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

resource "aws_iam_role_policy" "codepipeline_tf_deploy_attach_policy" {
  role   = aws_iam_role.codepipeline_tf_deploy.name
  policy = data.aws_iam_policy_document.codepipeline_tf_deploy.json
}

resource "aws_iam_role_policy" "codepipeline_tf_deploy_codebuild_perms" {
  role   = aws_iam_role.codepipeline_tf_deploy.name
  policy = data.aws_iam_policy_document.codebuild_tf_deploy.json
}
