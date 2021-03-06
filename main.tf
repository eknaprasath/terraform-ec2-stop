resource "aws_lambda_function" "test_lambda" {
  description = "Lambda function to stop start EC2 instances"
  filename      = "files/ec2-stop-start.zip"
  function_name = var.lambda_name
  role          = var.iam_role
  handler       = "ec2-stop-start.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("files/ec2-stop-start.zip")

  runtime = "python3.8"
  memory_size =  "128"
  timeout = "300"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


# resource "aws_lambda_permission" "cloudwatch_trigger" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
# }

# resource "aws_cloudwatch_event_rule" "lambda" {
#   name                = "${module.cwrule_name.name}"
#   description         = "Schedule trigger for lambda execution"
#   schedule_expression = "${var.schedule_expression}"
# }

# resource "aws_cloudwatch_event_target" "lambda" {
#   target_id = "${var.lambda_name}"
#   rule      = "${aws_cloudwatch_event_rule.lambda.name}"
#   arn       = "${join("", concat(aws_lambda_function.lambda_vpc.*.arn, aws_lambda_function.lambda_classic.*.arn))}"
# }

resource "aws_cloudwatch_event_rule" "cwevent" {
  name        = var.cloudwatch_event_name
  description = var.cloudwatch_event_description
  schedule_expression = var.cloudwatch_event_schedule_expression
}

resource "aws_cloudwatch_event_target" "cwtarget" {
  rule      = aws_cloudwatch_event_rule.cwevent.name
  target_id = "server-stop"
  arn       = aws_lambda_function.test_lambda.arn
}
