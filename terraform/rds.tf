resource "aws_db_instance" "default" {
  identifier = "${var.prefix}-db"

  allocated_storage     = 10
  max_allocated_storage = 100

  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "DevopsDB"
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.allow_mysql_rds.id]

  lifecycle {
    create_before_destroy = true
  }
}