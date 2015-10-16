# S3 Upload Script

GZIP, add sha for cache busting and upload to S3 with gzip encoding.

## Dependencies
**MAC:**
- `brew install md5sha1sum`
- `pip install awscli` (https://aws.amazon.com/cli/)

Or equivalent package on other OS

## To run
1. Add the images you want to upload to the images folder
2. Run the resize.sh and upload.sh scripts `export BUCKET="s3://your_bucket_name/"; bash resize.sh && bash upload.sh`
3. For resizing hero images use the resize-hero.sh script, the original image must be provided in 1920x823 size (21x9 aspect ratio)
4. You can determine the URLs from the console output or run `node index.js` to search with filenames
