resource "aws_security_group" "create_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  tags = var.sg_tags
}

resource "aws_security_group_rule" "public_access" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.create_sg.id
}

resource "aws_security_group_rule" "defined_ingress_rules" {
  count = length(var.ingress_rules)
  security_group_id = aws_security_group.create_sg.id
  description = var.rules[var.ingress_rules[count.index]][3]
  type              = "ingress"
  from_port         = var.rules[var.ingress_rules[count.index]][0]
  to_port           = var.rules[var.ingress_rules[count.index]][1]
  protocol          = var.rules[var.ingress_rules[count.index]][2]
  cidr_blocks       = var.ingress_cidr_blocks
  #cidr_blocks       = ["0.0.0.0/0"]
}

 resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_with_cidr_blocks)
  security_group_id = aws_security_group.create_sg.id
  type              = "ingress"
  cidr_blocks = split(
    ",",
    lookup(
      var.ingress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.ingress_cidr_blocks),
    ),
  )
    description = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
} 

resource "aws_security_group_rule" "egress_with_cidr_blocks" {
  count = length(var.egress_with_cidr_blocks)

  security_group_id = aws_security_group.create_sg.id
  type              = "egress"
  #cidr_blocks       = ["0.0.0.0/0"]

  cidr_blocks = split(
    ",",
    lookup(
      var.egress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.egress_cidr_blocks),
    ),
  )
  
  description = lookup(
    var.egress_with_cidr_blocks[count.index],
    "description",
    "Egress Rule",
  )

  from_port = lookup(
    var.egress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.egress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.egress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}


resource "aws_security_group_rule" "egress_rules" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
 # prefix_list_ids   = [aws_vpc_endpoint.my_endpoint.prefix_list_id]
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  # cidr_blocks      =  ["10.162.48.0/21"]  
security_group_id = aws_security_group.create_sg.id
}


