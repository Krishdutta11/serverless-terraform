resource "aws_sqs_queue" "standard_queue" {
  name                      = "POC-Queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  policy                    = aws_iam_policy.lambda_dynamo_sqs_apigw.policy
}
