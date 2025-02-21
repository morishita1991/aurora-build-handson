resource "aws_iam_role" "rds_enhanced_monitoring_role" {
  name               = "rds-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring_assume_role.json
}

data "aws_iam_policy_document" "rds_enhanced_monitoring_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring_attach" {
  role       = aws_iam_role.rds_enhanced_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}