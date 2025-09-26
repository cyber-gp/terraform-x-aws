resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { Name = "main-acl" })
}

# Inbound: allow SSH(22), HTTP(80), HTTPS(443)
resource "aws_network_acl_rule" "inbound_ssh" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "6" # tcp
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "inbound_http" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 110
  egress         = false
  protocol       = "6" # tcp
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "inbound_https" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 120
  egress         = false
  protocol       = "6" # tcp
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Inbound: allow ephemeral ports for return traffic
resource "aws_network_acl_rule" "inbound_ephemeral" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 130
  egress         = false
  protocol       = "6" # tcp
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Inbound: allow MySQL from the private subnets only
resource "aws_network_acl_rule" "inbound_mysql_a" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 140
  egress         = false
  protocol       = "6" # tcp
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidr_a
  from_port      = 3306
  to_port        = 3306
}

resource "aws_network_acl_rule" "inbound_mysql_b" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 150
  egress         = false
  protocol       = "6" # tcp
  rule_action    = "allow"
  cidr_block     = var.private_subnet_cidr_b
  from_port      = 3306
  to_port        = 3306
}

# Outbound: allow all
resource "aws_network_acl_rule" "outbound_all" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Associate ACL with subnets
resource "aws_network_acl_association" "public_assoc" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_network_acl_association" "private_assoc_a" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_network_acl_association" "private_assoc_b" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id      = aws_subnet.private_b.id
}