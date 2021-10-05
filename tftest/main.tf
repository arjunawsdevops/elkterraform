provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "elk" {
  count                        = "${var.server_count}"
  ami                          = "${var.ami}"
  instance_type                = "${var.instance_type}"
  subnet_id                    = "${var.subnet_id}"
  key_name                     = "${var.key_name}"
  security_groups              = ["${var.security_group_id}"]
  associate_public_ip_address  = "${var.public_ip_boolean}"
  root_block_device{
      volume_type           = "${var.volume_type}"
      volume_size           = "${var.volume_size}"
      delete_on_termination = "${var.delete_on_termination_boolean}"
 }
tags ={
    Name        = "ELKServer"
}
provisioner "file" {
  source     = "configfiles/"
  destination = "/tmp"
}
provisioner "remote-exec"{
inline = ["sleep 2m",
"sudo apt update",
"sudo apt install openjdk-8-jdk -y",
"export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64'",
"sudo echo 'export JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64'' >> ~/.bashrc",
"sudo echo 'export PATH=$JAVA_HOME/bin:$PATH' >>~/.bashrc",
". ~/.bashrc",
"sudo echo $JAVA_HOME",
"sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
"sudo apt-get install apt-transport-https -y",
"echo 'deb https://artifacts.elastic.co/packages/6.x/apt stable main' | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list",
"sudo apt-get update",
"sudo apt-get install elasticsearch -y",
"sudo cp -r /tmp/elasticsearch-defaults /etc/default/elasticsearch",
"sudo cp -r /tmp/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml",
"sudo systemctl enable elasticsearch.service",
"sudo systemctl restart elasticsearch.service",
"sleep 20s",
"sudo curl -XGET 'localhost:9200/?pretty'",
"sudo apt-get install kibana -y",
"sudo cp -r /tmp/kibana.yml /etc/kibana/kibana.yml",
"sudo systemctl enable kibana.service",
"sudo systemctl start kibana.service",
"sudo apt-get install nginx apache2-utils -y",
"sudo cp -r /tmp/nginx-config /etc/nginx/sites-available/default",
"echo 'EuN1M@rT#19' | sudo htpasswd -c -i /etc/nginx/.elkusersecret admin", 
"sudo nginx -t",
"sudo systemctl enable nginx.service",
"sudo systemctl restart nginx.service",
"sudo apt-get install logstash -y",
"sudo cp -r /tmp/filebeat-input.conf /etc/logstash/conf.d/filebeat-input.conf",
"sudo cp -r /tmp/syslog-filter.conf /etc/logstash/conf.d/syslog-filter.conf",
"sudo cp -r /tmp/output-elasticsearch.conf /etc/logstash/conf.d/output-elasticsearch.conf",
"sudo systemctl enable logstash.service",
"sudo systemctl start logstash.service",
"cd /usr/share/logstash",
"sudo bin/logstash-plugin install logstash-input-cloudwatch_logs",
"sudo cp -r /tmp/cloudwatch-input.conf /etc/logstash/conf.d/cloudwatch-input.conf",
"sudo systemctl start logstash.service"
]
}
connection {
  # To connect to machine
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("./eunimart-mongodb.pem")}"#pem file location to be specified
}
}
