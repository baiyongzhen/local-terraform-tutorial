terraform {
  source = "../../github.com/aws-s3"
}

include {
  path = "${find_in_parent_folders()}"
}

inputs ={
  name       = "iac"

  versioning = {
    enabled = false
  }

  attach_public_policy    = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }    
  }

  tags = {
      Service = "s3"
  }
}