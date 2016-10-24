#!/bin/sh
if [ $# != 1 ];then
    echo "Usage: post_name(建议用英文，不带空格)"
    exit
fi

post_name="$1"
date_format=`date '+%Y-%m-%d'`
year=`echo $date_format | cut -d '-' -f 1`

## post name
post_path="post/${year}/${date_format}-${post_name}.md"

## new post
hugo new ${post_path}

url_date_format=`date '+%Y/%m/%d'`
url="/${url_date_format}/${post_name}"

sed -i "" "s#title:.*#title: ${post_name}#" content/${post_path}
sed -i "" "s#url: \"\"#url: \"${post_name}\"#" content/${post_path}

vim content/${post_path}
