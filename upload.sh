#!/bin/bash

set -e

if [[ -z $BUCKET ]]; then
    echo "BUCKET is not set"

    exit 1
fi

rm -rf dist
mkdir dist

printf "Copying files to temporary directory... "
printf "Done"

find images -name ‘*.DS_Store’ -type f -delete

IFS=$'\n'
for filename in $(find images -type f ! -name ".DS_Store")
do
    file=`basename $filename`
    dir=`dirname $filename`

    if [[ -n $dir ]]; then
        dir="$dir/"
    fi

    mkdir -p dist/$dir

    file="${file%.*}"
    extension="${filename##*.}"
    hash=$(cat "$filename" | sha1sum | cut -f1 -d" ")
    hash=${hash:0:7}
    cp "$filename" "dist/${dir}${file}-$hash.${extension##*.}"
done

for filename in $(find dist -type f)
do
    gzip -t ${filename} > /dev/null 2>&1 || { echo "compressing ${filename}"; gzip -9 ${filename}; mv ${filename}.gz ${filename}; }
done

aws s3 sync dist ${BUCKET} --cache-control="max-age=31536000" --content-encoding="gzip"

printf "Cleaning up... "
printf "Done"
