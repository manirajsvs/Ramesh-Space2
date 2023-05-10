resource "aws_kms_key" "eks" {
 # description = "eks kms key for test"
  description = var.kms_key_description
  policy = data.aws_iam_policy_document.kms_policy_document.json
  enable_key_rotation = true
  #tags = var.kms_key_tags
}

resource "aws_kms_alias" "custom_key_alias" {
  name          = var.kms_key_name
  target_key_id = aws_kms_key.eks.key_id   
}

data "aws_iam_policy_document" "kms_policy_document" {
  dynamic "statement" {
    for_each = var.kms_policies_list
    content {
    principals {
      type        = statement.value["type"]
      identifiers = statement.value["identifier"]
    }
      sid = statement.value["sid"]
      actions = statement.value["actions"]
      resources = statement.value["resources"]
  condition {
      test = statement.value["query"]
      variable = statement.value["var"]
      values = statement.value["reg"]
      }
  }
}
}
