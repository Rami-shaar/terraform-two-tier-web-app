resource "aws_launch_template" "ec2_template" {
  name_prefix   = "web-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
echo "Hello from EC2 instance" > /var/www/html/index.html
EOF
  )
}

resource "aws_autoscaling_group" "ec2_asg" {
  desired_capacity     = 2
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = var.private_subnet_ids

  target_group_arns = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.ec2_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60
}

resource "aws_lb" "my_alb" {
  name               = "web-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.elb_sg.id]
}

resource "aws_lb_target_group" "web_tg" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP from the internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow traffic from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
