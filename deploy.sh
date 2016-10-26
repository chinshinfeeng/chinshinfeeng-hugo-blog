#!/bin/sh
set +x
if [ $# != 2 ];then
   echo "Usage: auto/manual/first theme"
   exit
fi
choice="$1"
theme="$2"

git_prefix="git@github.com:chinshinfeeng/"
branch="gh-pages"
if [ "$theme" = "polymer" ];then
    repo="chinshinfeeng-blog-polymer"
    cname="blog.chinshinfeeng.org"
    cp themes/$theme/config.toml .
elif [ "$theme" = "rapid" ];then
    repo="chinshinfeeng-blog-deployed"
    cname="www.chinshinfeeng.org"
    cp themes/$theme/config.yaml .
else
    echo "$theme not exit"
    exit
fi
date_format=`date '+%Y-%m-%d'`
current_dir=`pwd`
dest_dir=`cd .. && pwd`"/${date_format}tmp"

echo $dest_dir
mkdir -p $dest_dir
cd $current_dir

## hugo 
hugo -v --cacheDir="./cache"

commit_msg=`git log -1 --pretty=format:"%s"`
cp -r public/ $dest_dir
cd $dest_dir

ls
case $choice in
    first)
       git init
       git remote add origin $git_prefix$repo.git
       git fetch origin
       git checkout --orphan tmp
       git rm --cached -r .
       git clean -fdx
       git branch -D $branch
       git checkout -b $branch
       ;;
    auto)
       git init
       git remote add origin $git_prefix$repo.git
       git fetch origin
       git checkout $branch
       ;;
    manual)
       ;;
    *)
       echo "Usage: auto/first/manual"
       exit
       ;;
esac

cp -r $current_dir/public/ $dest_dir

echo $cname > CNAME
git add -A
echo "======msg is: $commit_msg======"
git commit -m "$commit_msg" 
git push origin $branch:$branch -u

rm $current_dir/config.*
