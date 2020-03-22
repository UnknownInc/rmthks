import express from 'express';
import morgan from 'morgan';
import fs from 'fs';
import path from 'path';
import bodyParser from 'body-parser';
import { v4 as uuidv4 } from 'uuid'; // For version 5
const tempDirectory = require('temp-dir');

const app = express();

app.use(require('cors')());
app.use(morgan('common'))

app.use(express.static('public',{}));
app.use(bodyParser.urlencoded({ extended: true, limit: "50mb" }));
app.use(bodyParser.json({limit:"50mb"})); //Used to parse JSON bodies

function basicAuth(req, res, next) {
  // make authenticate path public
  if (req.path === '/users/authenticate') {
      return next();
  }

  // check for basic auth header
  if (!req.headers.authorization || req.headers.authorization.indexOf('Basic ') === -1) {
      return res.status(401).json({ message: 'Missing Authorization Header' });
  }

  // verify auth credentials
  const base64Credentials =  req.headers.authorization.split(' ')[1];
  const credentials = Buffer.from(base64Credentials, 'base64').toString('ascii');
  const [username, password] = credentials.split(':');

  if (username==process.env.RMTHKS_AUSER &&
    password==process.env.RMTHKS_APASS 
    ) {
    req.user = {};
  }

  next();
}


const {Storage} = require('@google-cloud/storage');

app.post("/login", function(req, res){
  if (req.body.username==process.env.RMTHKS_AUSER &&
    req.body.password==process.env.RMTHKS_APASS 
    ) {
    return res.send('ok');
  }
  return res.sendStatus(403);
})

app.get("/uploads",basicAuth, async function(req, res) {
  if (!req.user) return res.sendStatus(403);
  const [files] = await storage.bucket('rmthks').getFiles({prefix:'uploads'});
  var items=[];
  console.log('Files:');
  files.forEach(file => {
    console.log(file.name);
    if (file.metadata.metadata) {
      var item = {...file.metadata.metadata}; 
      item.image="https://storage.googleapis.com/rmthks/"+file.name;
      items.push(item);
    }
  });
  res.json(items);
})

app.post("/publish", basicAuth, async function(req, res) {
  if (!req.user) return res.sendStatus(403);
  if (!req.body.image) return res.sendStatus(400);

  var parts=req.body.image.split('rmthks/');
  console.log(parts[1]);
  const bucket = storage.bucket('rmthks');
  const file = bucket.file(parts[1]);
  file.move(parts[1].replace('uploads/','public/'), function(err, _newFile, _apiResponse) {
    if (err) return res.sendStatus(500);
    return res.send('ok');
  })
});

// Creates a client
const storage = new Storage({
  projectId: process.env.GOOGLE_CLOUD_PROJECT+'',
  keyFilename: process.env.GCLOUDKEYFILE+''});

app.post("/upload", function(req, res) {
  var name = req.body.name.trim();
  var imagename = req.body.imagename
  var ext = path.extname(imagename);
  var age = req.body.age;
  var email = req.body.email.trim();
  var img = req.body.image;
  var realFile = Buffer.from(img,"base64");
  var prefix = uuidv4();
  var sp = process.env.RMTHKS_SAVELOCAL ? process.env.RMTHKS_UPLOADDIR : tempDirectory;
  var ipath=path.join(sp,prefix+ext);
  console.info('creating tempfile in '+ipath); 
  fs.writeFile(ipath , realFile, function (err){
    if(err) {
      console.error(err);
      return res.sendStatus(500);
    }
    const bucket = storage.bucket('rmthks');
    const options = {
      destination: `uploads/${prefix}${ext}`,
      resumable: true,
      validation: 'crc32c',
      metadata: {
        // Enable long-lived HTTP caching headers
        // Use only if the contents of the file will never change
        // (If the contents will change, use cacheControl: 'no-cache')
        cacheControl: 'public, max-age=31536000',
        metadata: {
          name, age, email
        }
      }
    };
    bucket.upload(ipath, options, function(err, file) {
      if(err) {
        console.error(err);
        return res.sendStatus(500); 
      }
      console.info(file.name);
      fs.unlink(ipath,(err)=>{console.error(err);});
      res.send("OK");
    });
  });
});

app.get('/published',async (_req, res) => {
  const [files] = await storage.bucket('rmthks').getFiles({prefix:'public'});
  var items=[];
  console.log('Files:');
  files.forEach(file => {
    console.log(file.name);
    if (file.metadata.metadata) {
      var item = {...file.metadata.metadata}; 
      item.image="https://storage.googleapis.com/rmthks/"+file.name;
      items.push(item);
    }
  });
  res.json(items);
});

app.get('/ping', async (_req, res) => {
  const [files] = await storage.bucket('rmthks').getFiles({prefix:'uploads', delimiter:'/'});

  console.log('Files:');
  files.forEach(file => {
    console.log(file.name);
  });
  // Uploads a local file to the bucket
  // await storage.bucket(bucketName).upload(filename, {
  //   // Support for HTTP requests made with `Accept-Encoding: gzip`
  //   gzip: true,
  //   // By setting the option `destination`, you can change the name of the
  //   // object you are uploading to a bucket.
  //   metadata: {
  //     // Enable long-lived HTTP caching headers
  //     // Use only if the contents of the file will never change
  //     // (If the contents will change, use cacheControl: 'no-cache')
  //     cacheControl: 'public, max-age=31536000',
  //   },
  // });
  res.send('pong');
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.info('rmthks listening on port', port);
});