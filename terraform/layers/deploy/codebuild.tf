resource "aws_codebuild_project" "github_tf_deploy_base" {
  name          = "github-${var.environment}-${var.project_name}-base"
  description   = "Github terraform pipeline"
  build_timeout = "120"
  service_role  = aws_iam_role.codebuild_tf_deploy.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  concurrent_build_limit = 1

  environment {
    compute_type                = var.codebuild_node_size
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type = "CODEPIPELINE"
    buildspec = templatefile("./src/build/buildspec.yaml", {
      aws_account_id   = data.aws_caller_identity.current.account_id
      aws_region       = var.region
      environment      = var.environment
      tf_version       = var.terraform_version
      tf_deploy_config = "${var.environment}-${var.project_name}"
      tf_deploy_layer  = "base"
    })
  }
}
