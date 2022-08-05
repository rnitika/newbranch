variable "main_region" {
  type = string
  default = "us-east-1"
}

provider "aws"{
	region = var.main_region
        access_key = "AKIAXRGVXBCCW2WUWVXE"
	secret_key = "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"
}

module "vpc" {
	source = "./modules/vpc"
}
resource "aws_key_pair" "my-key"{
         key_name = "my-key"
	 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsJgZBbWFIC77TGPqHvKZVhyHM57QNSigEazveTKyll+ZHi/4pOWwu29BruHupfyX3oLGQGPwa1jyEczefJ/sU7R/zUdbhbfw56erk5znZTwSlubWCjwCMiHLGOIGumVC6Z6Fjk2JpM334/ADslcUvSvmutyG/dkwWuJeOySh0A2WLR7iSmyDDGf35mIyj9s8oWqRbqOJFbMiEYgfQPPnkRNXsiX8c2gMa2jGuvCu9vGQ4vu4XKaIvtSYheGGT0E2JeYMeAS14DF6v+pcoXdMeEvJ3tc89jf3Mo/DK9PMkKXabgfCeKq2J5NjcE+WE6Pbi3D9J9VBTdg5PTnoOp6Ql root@ip-172-31-23-144.ec2.internal"
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

