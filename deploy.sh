#!/bin/sh

if [ $# != 1 ];then
   echo "Usage: auto/manual/first"
   exit
fi
choice="$1"

git_prefix="git@github.com:chinshinfeeng/"
branch="gh-pages"
repo="chinshinfeeng-blog-polymer"
cname="blog.chinshinfeeng.org"

date_format=`date '+%Y-%m-%d'`
current_dir=`pwd`
dest_dir=`cd .. && pwd`"/${date_format}tmp"

echo $dest_dir
mkdir -p $dest_dir
cd $current_dir

## hugo 
hugo

commit_msg=`git log -1 --pretty=format:"%s"`
cp -r public/ $dest_dir
cd $dest_dir

ls
case $choice in
    first)
       git init
       echo $cname > CNAME
       git add -A
       git commit -m "$commit_msg" 
       git remote add origin $git_prefix$repo.git
       git push -u origin master
       ;;
    auto)
       ;;
    manual)
       ;;
    *)
       echo "Usage: auto/first/manual"
       exit
       ;;
esac

#git push origin $branch:$branch
