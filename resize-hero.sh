quality=90

mkdir -p images/large
mkdir -p images/medium
mkdir -p images/small

find images -name ‘*.DS_Store’ -type f -delete
IFS=$'\n'
for file in $(find images -maxdepth 1 -type f ! -name ".DS_Store" ! -name ".gitkeep"); do
  img=`basename "$file"`

  size=`convert "$file" -print "%wx%h\n" /dev/null`

  if [ $size = '1920x823' ]
  then
	  echo "Processing $file with quality $quality"
	  convert -resize 1920 "$file" pnm:- | mozcjpeg -quality "$quality" > "images/large/${img%.*}.jpg"
	  convert -resize 1280 "$file" pnm:- | mozcjpeg -quality "$quality" > "images/medium/${img%.*}.jpg"
	  convert -resize 800 "$file" pnm:- | mozcjpeg -quality "$quality" > "images/small/${img%.*}.jpg"
  else
    echo "ERROR: wrong image size $size for '$file', expected 1920x823" 
    exit 1
  fi

done
