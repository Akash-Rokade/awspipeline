resource "aws_sns_topic" "my_sns_topic" {
  name = "mysnsautomation"
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.my_sns_topic.arn
  protocol  = "email"
  endpoint  = "akash_rokade@epam.com"
  endpoint_auto_confirms = true
}

resource "aws_codepipeline" "pipeline" {
  name     = "web-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn
  tags = {
    Environment = var.env
  }

  artifact_store {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "Branch"               = var.repository_branch
        "Owner"                = var.repository_owner
        "PollForSourceChanges" = "false"
        "Repo"                 = var.repository_name
        OAuthToken             = var.github_token
      }

      input_artifacts = []
      name            = "Source"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "ThirdParty"
      provider  = "GitHub"
      run_order = 1
      version   = "1"
    }
  }


    stage {
    name = "Terraform_Build"

    action {
      name             = "Terraform-Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "project-build"
      }
    }
  }

stage {
    name = "Terraform_Plan"

    action {
      name             = "Terraform-Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "project-build-plan"
      }
    }
  }

stage {
  name = "Manual_Approval"

  action {
    name     = "Manual-Approval"
    category = "Approval"
    owner    = "AWS"
    provider = "Manual"
    version  = "1"
    configuration ={
       NotificationArn = aws_sns_topic.my_sns_topic.arn
    }
  }
}

stage {
    name = "Terraform_Apply"

    action {
      name            = "Terraform-Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ProjectName = "project-build-apply"
      }
    }
  }
depends_on = [aws_sns_topic.my_sns_topic]
}
