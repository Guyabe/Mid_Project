resource "aws_launch_template" "ec2_app_template" {
  name_prefix = "ec2-launch-template"

  image_id          = "ami-0ebfd941bbafe70c6" 
  instance_type = "t2.micro"


  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ec2_app_sg.id]
  }

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-launch-template" })

  user_data = base64encode(file("../application/stock-app/userdata.sh"))

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_template" "ec2_monitoring_template" {
  name_prefix = "ec2-launch-template"

  image_id          = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"


  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ec2_monitoring_sg.id]
  }

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-launch-template" })


  user_data = base64encode(file("../application/userdata.sh"))

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_launch_template" "ec2_db_template" {
  name_prefix = "ec2-mongo-template"

  image_id          = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"


  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [aws_security_group.ec2_mongo_sg.id]
  }

  tags = merge(local.tags, { Name = "${local.tags.Environment}-ec2-launch-template" })


  user_data = base64encode(file("../application/mongo/user-data.sh"))

  lifecycle {
    create_before_destroy = true
  }
}
