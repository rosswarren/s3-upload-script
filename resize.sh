quality=90

mkdir -p images/large
mkdir -p images/medium
mkdir -p images/small

find images -name ‘*.DS_Store’ -type f -delete
IFS=$'\n'
for file in $(find images -maxdepth 1 -type f ! -name ".DS_Store"); do
  img=`basename "$file"`

  echo "Processing $file with quality $quality"
  convert -resize 1200 "$file" pnm:- | mozcjpeg -quality "$quality" > "images/large/${img%.*}.jpg"
  convert -resize 1024 "$file" pnm:- | mozcjpeg -quality "$quality" > "images/medium/${img%.*}.jpg"
  convert -resize 640 "$file" pnm:- | mozcjpeg -quality "$quality" > "images/small/${img%.*}.jpg"
done
