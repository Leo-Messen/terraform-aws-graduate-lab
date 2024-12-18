resource "aws_codepipeline" "tf_codepipeline" {
  name           = "gh-tf-pipeline"
  role_arn       = aws_iam_role.codepipeline_tf_deploy.arn
  pipeline_type  = "V2"
  execution_mode = "QUEUED"

  artifact_store {
    location = aws_s3_bucket.codepipeline_tf_deploy.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "${var.gh_org_name}-${var.tf_gh_repo_name}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_tf_output"]
      region           = var.region

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_connection.arn
        FullRepositoryId = "${var.gh_org_name}/${var.tf_gh_repo_name}"
        BranchName       = var.gh_branch
      }
    }
  }

  stage {
    name = "DeployBase"

    action {
      name             = "BaseLayer"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_tf_output"]
      output_artifacts = ["base_build_output"]
      version          = "1"

      configuration = {
        ProjectName = "github-${var.environment}-${var.project_name}-base"
      }
    }
  }

  stage {
    name = "DeployApp"

    action {
      name             = "AppLayer"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["base_build_output"]
      output_artifacts = ["app_build_output"]
      version          = "1"

      configuration = {
        ProjectName = "github-${var.environment}-${var.project_name}-app"
      }
    }
  }
}
