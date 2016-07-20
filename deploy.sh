#!/bin/bash

organization="ericcitaire"
project_repo="test-travis"
site_repo="test-travis-site"

build_dir="${PWD}/target"

encrypted_key="${encrypted_6b7ea0692d18_key}"
encrypted_iv="${encrypted_6b7ea0692d18_iv}"

git config --global user.email "build@travis-ci.org"
git config --global user.name "Travis-CI"

openssl aes-256-cbc -K "${encrypted_key}" -iv "${encrypted_iv}" -in id_rsa.enc -out id_rsa -d
chmod 400 id_rsa

cat <<EOT > ~/.ssh/config
host github.com
 HostName github.com
 IdentityFile ${PWD}/id_rsa
 User git
EOT

git clone "git@github.com:${organization}/${site_repo}.git"

cd "${site_repo}"

if [ -d demo ] ; then
  git rm demo
fi
mkdir demo
cd demo

unzip "${build_dir}/travis-test-1.0-SNAPSHOT.war" -x "META-INF/*" "WEB-INF/*"

git add .
git commit -m "Update demo"
git push

