################################################################################
# Codestar github connection
resource "aws_codestarconnections_connection" "github_connection" {
  name          = "${var.project_name}-github-connection"
  provider_type = "GitHub"
}
