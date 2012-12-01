#!/bin/sh

FILE=`mktemp`
wget -O $FILE http://someonewhocares.org/hosts/hosts

# Enable everything
sed -i 's/#127/127/g' $FILE

# Remove local settings
sed -i '/#<localhost>/,/#<\/localhost>/d' $FILE

cat hosts_local $FILE > hosts