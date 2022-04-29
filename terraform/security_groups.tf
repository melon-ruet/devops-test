resource "aws_security_group" "allow_mysql_rds" {
  name        = "${var.prefix}-mysql-sg-rds"
  description = "Allow Mysql inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "Mysql port from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-mysql-sg-rds"
  }
}

resource "aws_security_group" "allow_mysql_ecs" {
  name        = "${var.prefix}-mysql-sg-ecs"
  description = "Allow Mysql inbound traffic"
  vpc_id      = data.aws_vpc.default.id

#  ingress {
#    description      = "Mysql port from VPC"
#    from_port        = 3306
#    to_port          = 3306
#    protocol         = "tcp"
#    cidr_blocks      = [data.aws_vpc.default.cidr_block]
#    ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
#  }

  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.prefix}-mysql-sg-ecs"
  }
}