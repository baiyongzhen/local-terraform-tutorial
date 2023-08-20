terraform {
    source = "../../../../github.com/aws-iam/iam-policy"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

inputs ={
  name          = "nginx"
  attributes    = ["service"]

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucketMultipartUploads",
                "s3:ListBucketVersions",
                "s3:ListBucket",
                "s3:ListMultipartUploadParts",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::dev-apne2-kr-deploy-s3",
                "arn:aws:s3:::dev-apne2-kr-deploy-s3/*"
            ]
        }
    ]
}
EOF

  tags = {
      Service = "nginx"
  }

}