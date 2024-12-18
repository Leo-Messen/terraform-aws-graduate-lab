resource "aws_cloudwatch_log_group" "tf_deploy" {
  name = "${var.environment}-${var.project_name}"
}

resource "aws_cloudwatch_log_stream" "codebuild_tf_deploy" {
  name           = "CodeBuild"
  log_group_name = aws_cloudwatch_log_group.tf_deploy.name
}

resource "aws_cloudwatch_log_stream" "codepipeline_tf_deploy" {
  name           = "CodePipeline"
  log_group_name = aws_cloudwatch_log_group.tf_deploy.name
}

data "aws_iam_policy_document" "codebuild_tf_deploy_log_publishing" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = ["arn:aws:logs:*"]

    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "codebuild_tf_deploy" {
  policy_document = data.aws_iam_policy_document.codebuild_tf_deploy_log_publishing.json
  policy_name     = "codebuild-tf-deploy-log-publishing-policy"
}
