#!/bin/bash
sleep 30
set -e  # Exit immediately if any command fails

# Install httpd (Apache HTTP Server)
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Download and deploy website
sudo mkdir -p /var/www/html
sudo curl -L "https://www.free-css.com/assets/files/free-css-templates/download/page292/yogast.zip" -o /tmp/yogast.zip
sudo yum install -y unzip
sudo unzip /tmp/yogast.zip -d /tmp
sudo mv /tmp/yogast-html/* /var/www/html/
sudo rm -rvf /tmp/yogast.zip /tmp/yogast-html

# Ensure correct permissions for web files (optional)
sudo chown -R apache:apache /var/www/html

# Restart httpd to apply changes (optional)
sudo systemctl restart httpd

# Example: Log successful completion (optional)
echo "User data script executed successfully" >> /var/log/userdata.log
