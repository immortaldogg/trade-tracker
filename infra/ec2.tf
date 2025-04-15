resource "aws_key_pair" "backend_key" {
  key_name   = "trt-be-key"
  public_key = file("~/.ssh/trt-be-key.pub")
}

resource "aws_instance" "backend" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  key_name                    = aws_key_pair.backend_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "backend-server"
  }
}
