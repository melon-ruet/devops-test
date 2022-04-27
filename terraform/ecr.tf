// Frontend upload docker image
locals {
  frontend_dockerfile_dir      = "${path.module}/../frontend"
  frontend_dockerfile_dir_hash = data.external.frontend_dockerfile_hash.result.md5_hash
}

resource "aws_ecr_repository" "frontend" {
  name                 = "${var.prefix}-frontend-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "external" "frontend_dockerfile_hash" {
  program = ["/bin/bash", "-c", "echo '{\"md5_hash\": \"'$(find ${local.frontend_dockerfile_dir} -type f -exec md5sum {} + | LC_ALL=C sort | md5sum | cut -d' ' -f1)'\"}'"]
}

resource "null_resource" "upload_frontend_image" {
  triggers = {
    docker_dir_change = local.frontend_dockerfile_dir_hash
  }

  provisioner "local-exec" {
    command = "${path.module}/push_image.sh \"${aws_ecr_repository.frontend.repository_url}\" \"${local.frontend_dockerfile_dir}\" \"${local.frontend_dockerfile_dir_hash}\" \"${var.aws_profile}\""
  }
}


// backend upload docker image
locals {
  backend_dockerfile_dir      = "${path.module}/../backend"
  backend_dockerfile_dir_hash = data.external.backend_dockerfile_hash.result.md5_hash
}

resource "aws_ecr_repository" "backend" {
  name                 = "${var.prefix}-backend-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "external" "backend_dockerfile_hash" {
  program = ["/bin/bash", "-c", "echo '{\"md5_hash\": \"'$(find ${local.backend_dockerfile_dir} -type f -exec md5sum {} + | LC_ALL=C sort | md5sum | cut -d' ' -f1)'\"}'"]
}

resource "null_resource" "upload_backend_image" {
  triggers = {
    docker_dir_change = local.backend_dockerfile_dir_hash
  }

  provisioner "local-exec" {
    command = "${path.module}/push_image.sh \"${aws_ecr_repository.backend.repository_url}\" \"${local.backend_dockerfile_dir}\" \"${local.backend_dockerfile_dir_hash}\" \"${var.aws_profile}\""
  }
}