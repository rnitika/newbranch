output "subnet_id"{
	value = aws_subnet.my-subnet.id
}
output "ami_id"{
	value = data.aws_ssm_parameter.this.value
}
