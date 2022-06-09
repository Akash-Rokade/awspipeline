resource "aws_codebuild_project" "project_build" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "project-build"
  queued_timeout = 480
  service_role   = aws_iam_role.static_build_role.arn
  tags = {
    Environment = var.env
  }

artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    location            = "https://github.com/Akash-Rokade/task/"
    buildspec           = "buildspec_terraform_build.yml"
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "GITHUB"
  }
}




resource "aws_codebuild_project" "project_build_plan" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "project-build-plan"
  queued_timeout = 480
  service_role   = aws_iam_role.static_build_role.arn
  tags = {
    Environment = var.env
  }

artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    location            = "https://github.com/Akash-Rokade/task/"
    buildspec           = "buildspec_terraform_plan.yml"
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "GITHUB"
  }
}



resource "aws_codebuild_project" "project_build_apply" {
  badge_enabled  = false
  build_timeout  = 60
  name           = "project-build-apply"
  queued_timeout = 480
  service_role   = aws_iam_role.static_build_role.arn
  tags = {
    Environment = var.env
  }

artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    location            = "https://github.com/Akash-Rokade/task/"
    buildspec           = "buildspec_terraform_apply.yml"
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "GITHUB"
  }
}

