import express from 'express';

const app = express();

app.get('/', (_req, res) => {
  res.send('Servidor no ar!');
});

export default app;