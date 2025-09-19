resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { Name = "main-acl" })
}

# Inbound: allow SSH(22), HTTP(80), and ephemeral return ports
resource "aws_network_acl_rule" "inbound_ssh_http" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number = 100
  egress = false
  protocol = "6" # tcp
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 80
}

# Inbound: allow MySQL from the private subnet only (optional)
resource "aws_network_acl_rule" "inbound_mysql" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number = 110
  egress = false
  protocol = "6" # tcp
  rule_action = "allow"
  cidr_block = aws_subnet.private.cidr_block
  from_port = 3306
  to_port = 3306
}

# Outbound: allow all
resource "aws_network_acl_rule" "outbound_all" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number = 100
  egress = true
  protocol = "-1"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 0
}

# Associate ACL with subnets
resource "aws_network_acl_association" "public_assoc" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id = aws_subnet.public.id
}

resource "aws_network_acl_association" "private_assoc" {
  network_acl_id = aws_network_acl.main_acl.id
  subnet_id = aws_subnet.private.id
}