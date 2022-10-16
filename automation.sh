#Variables

name="nishant"
s3_bucket="upgrad-nishant"

apt update -y

#check for apache2 installation

if [[ apache2 !=$(dpkg --get-selections apache2 | aws '{print $1}') ]]; then
	apt install apache2 -y
fi

#Check for apache2 service is running

running=$(systemctl status apache2 | grep active | aws '{print $3}' | tr -d '()')
if [[ running != ${running} ]]; then
	systemctl start apache2
fi

#Check for apache2 service is enabled
enabled=$(systemctl is-enabled apche2 | grep "enabled")
if [[ enabled != $(enabled) ]]: then
	systemctl enable apache2
fi

#creation of file
timestamp=$(date '+%d%m%Y-%H%M%S')

cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

if [[ -f /tmp/${name}-httpd-logs-${timestamp} ]]; then
	aws cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
fi
