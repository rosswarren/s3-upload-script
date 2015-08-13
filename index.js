var readline = require('readline');
var AWS = require('aws-sdk');
var s3 = new AWS.S3();

var urlPrefix = 'http://dm8eklel4s62k.cloudfront.net/images/';
var foldersRegex = /images\/(small|medium|large)\/(.*)/;

function search() {
  var rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  rl.question("Search: ", function(answer) {
    rl.close();

    s3.listObjects({
      Bucket: 'polaris-assets',
      Prefix: 'images'
    }, function (err, data) {
      var collection = {};
      collection['panelImage'] = collection['tileImage'] = {};
      data.Contents.forEach(function (item) {
        if(item.Key.toLowerCase().indexOf(answer.toLowerCase()) > -1) {
          var parts = item.Key.match(foldersRegex);
          if(parts) {
            var size = parts[1];
            var filename = encodeURIComponent(parts[2]);

            collection['panelImage'][size] = urlPrefix + size + "/" + filename;
          }
        }
      });
      console.log('"tileImage":', JSON.stringify(collection['tileImage'],null, ' ') + ',');
      console.log('"panelImage":', JSON.stringify(collection['panelImage'],null, ' ') + ',');
      search();
    });
  });
}
search();
