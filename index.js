var readline = require('readline');
var AWS = require('aws-sdk');
var s3 = new AWS.S3();

var urlPrefix = 'http://dm8eklel4s62k.cloudfront.net/images/';
var foldersRegex = /images\/(small|medium|large)\/(.*)/;

function search(term, nextMarker, acc) {
    var settings = {
        Bucket: 'polaris-assets',
        Prefix: 'images'
    };

    if (nextMarker) {
        settings['Marker'] = nextMarker;
    }

    s3.listObjects(settings, function(err, data) {
        var marker;
        var collection = acc;
        if (acc) {
            collection = acc;
        } else {
            collection = {};
            collection['panelImage'] = collection['tileImage'] = {};
        }
        data.Contents.forEach(function(item) {
            marker = item.Key;
            if (item.Key.toLowerCase().indexOf(term.toLowerCase()) > -1) {
                var parts = item.Key.match(foldersRegex);
                if (parts) {
                    var size = parts[1];
                    var filename = encodeURIComponent(parts[2]);

                    collection['panelImage'][size] = urlPrefix + size + "/" + filename;
                }
            }
        });
        if (data.IsTruncated) {
            search(term, marker, collection);
        } else {
            console.log('"tileImage":', JSON.stringify(collection['tileImage'], null, ' ') + ',');
            console.log('"panelImage":', JSON.stringify(collection['panelImage'], null, ' ') + ',');
            promptForSearch();
        }
    });
}

function promptForSearch() {
    var rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question("Search: ", function(answer) {
        rl.close();

        search(answer);
    });
}

promptForSearch();
