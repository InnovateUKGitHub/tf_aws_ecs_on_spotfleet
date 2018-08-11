resource "aws_iam_instance_profile" "app" {
  name = "${var.app_name}-app-instance"
  role = "${aws_iam_role.app_instance.name}"
}

resource "aws_iam_policy_attachment" "app_instance" {
  name       = "${var.app_name}-app-instance"
  roles      = ["${aws_iam_role.app_instance.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "app_instance" {
  name = "${var.app_name}-app-instance"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
}
EOF
}

resource "aws_security_group" "app_instance" {
  name        = "${var.app_name}-app-instance"
  description = "container security group for ${var.app_name}"
  vpc_id      = "${var.vpc}"

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    security_groups = ["${aws_security_group.app_alb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy_attachment" "fleet" {
  name       = "${var.app_name}-fleet"
  roles      = ["${aws_iam_role.fleet.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetRole"
}

resource "aws_iam_role" "fleet" {
  name = "${var.app_name}-fleet"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "spotfleet.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_spot_fleet_request" "main" {
  iam_fleet_role                      = "${aws_iam_role.fleet.arn}"
  spot_price                          = "${element(var.spot_prices, 0)}"
  allocation_strategy                 = "${var.strategy}"
  target_capacity                     = "${var.instance_count}"
  terminate_instances_with_expiration = true
  valid_until                         = "${var.valid_until}"

  launch_specification {
    ami                    = "${var.ami}"
    instance_type          = "${var.instance_type}"
    spot_price             = "${element(var.spot_prices, 0)}"
    subnet_id              = "${element(var.subnets, 0)}"
    vpc_security_group_ids = ["${aws_security_group.app_instance.id}"]
    iam_instance_profile   = "${aws_iam_instance_profile.app.name}"
    key_name               = "${var.key_name}"

    root_block_device = {
      volume_type = "gp2"
      volume_size = "${var.volume_size}"
    }
  }

  launch_specification {
    ami                    = "${var.ami}"
    instance_type          = "${var.instance_type}"
    spot_price             = "${element(var.spot_prices, 1)}"
    subnet_id              = "${element(var.subnets, 1)}"
    vpc_security_group_ids = ["${aws_security_group.app_instance.id}"]
    iam_instance_profile   = "${aws_iam_instance_profile.app.name}"
    key_name               = "${var.key_name}"

    root_block_device = {
      volume_type = "gp2"
      volume_size = "${var.volume_size}"
    }
  }

  launch_specification {
    ami                    = "${var.ami}"
    instance_type          = "${var.instance_type}"
    spot_price             = "${element(var.spot_prices, 2)}"
    subnet_id              = "${element(var.subnets, 2)}"
    vpc_security_group_ids = ["${aws_security_group.app_instance.id}"]
    iam_instance_profile   = "${aws_iam_instance_profile.app.name}"
    key_name               = "${var.key_name}"

    root_block_device = {
      volume_type = "gp2"
      volume_size = "${var.volume_size}"
    }
  }

  depends_on = ["aws_iam_policy_attachment.fleet"]
}
