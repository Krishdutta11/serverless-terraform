# Create IAM Roles
resource "aws_iam_role" "role1" {
  name                = "Lambda-SQS-DynamoDB"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_lambda.json
  managed_policy_arns = [aws_iam_policy.lambda_dynamo_sqs_apigw.arn]
}

resource "aws_iam_role" "role2" {
  name                = "Lambda-DynamoDBStreams-SNS"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_lambda.json
  managed_policy_arns = [aws_iam_policy.lambda_dynamostreams.arn, aws_iam_policy.lambda_sns.arn]
}

resource "aws_iam_role" "api" {
  name = "my-api-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
