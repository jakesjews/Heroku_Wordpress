#! /bin/bash
curl -O http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz
cd wordpress
cp wp-config-sample.php wp-config.php

sed -i '.original' -e '/MySQL settings/i \
$db = parse_url($_SERVER['\''CLEARDB_DATABASE_URL'\'']); \
' wp-config.php

sed -i '.original' -e "s/'database_name_here'/trim(\$db['path'],'\/')/" wp-config.php
sed -i '.original' -e "s/'username_here'/\$db['user']/" wp-config.php
sed -i '.original' -e "s/'password_here'/\$db['pass']/" wp-config.php
sed -i '.original' -e "s/'localhost'/\$db['host']/" wp-config.php

git init .
git add .
git commit -am "first commit"

heroku create --stack cedar
heroku addons:add cleardb:ignite

git push heroku master

heroku open