apt-get install unzip -y
apt-get install libwww-perl libdatetime-perl -y
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip
rm CloudWatchMonitoringScripts-1.2.2.zip
cd aws-scripts-mon
/home/ubuntu/disk-usage-script/aws-scripts-mon/mon-put-instance-data.pl --mem-util --verify --verbose
echo "*/1 * * * *  /home/ubuntu/disk-usage-script/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-space-used --disk-space-avail --disk-path=/ --from-cron" >> mycron
crontab mycron