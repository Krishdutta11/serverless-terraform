# Create DynamoDB table
resource "aws_dynamodb_table" "dynamodb-table" {
  name             = "orders"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "orderID"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "orderID"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "ordersTable"
    Environment = "production"
  }
}
