import express from 'express';
import morgan from 'morgan';

const app = express();

app.use(morgan('common'))

app.use(express.static('public',{}));

app.get('/ping', (_req, res) => {
  res.send(`pong`);
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.info('rmthks listening on port', port);
});