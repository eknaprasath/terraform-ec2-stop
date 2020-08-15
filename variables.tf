variable "iam_role" {
  type        = string
  default     = "arn:aws:iam::356143132518:role/lambda_iam_role"
  description = "Lambda IAM Role"
}
variable "lambda_name" {
  type        = string
  default     = "ec2-start-stop"
  description = "lamda function name"
}
variable "cloudwatch_event_name" {
  type        = string
  default     = "ec2-instance-stop"
  description = "cloudwatch event name"
}
variable "cloudwatch_event_description" {
  type        = string
  default     = "cloudwatch event to stoping ec2 instance"
  description = "description"
}
variable "cloudwatch_event_schedule_expression" {
  type        = string
  default     = "cron(0 20 * * ? *)"
  description = "description"
}
