variable "main_region" {
  type = string
  default = "us-east-1"
}

provider "aws"{
	region = var.main_region
        access_key = "acess_key"
	secret_key = "secret_key"
}

module "vpc" {
	source = "./modules/vpc"
}
resource "aws_key_pair" "my-key"{
         key_name = "my-key"
	 public_key = "public_key"
}

resource "aws_instance" "my-instance" {
	instance_type = "t2.micro"
	key_name      = "my-key"
	ami	      = module.vpc.ami_id
        subnet_id     = module.vpc.subnet_id
tags = {
    Name = "terraform-webserver"
  }

provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl restart httpd"
    ]
} 
connection {
    host        = self.public_ip
    user        = "ec2-user"
    type        = "ssh"
    private_key = file("./my-key")
  }


}

