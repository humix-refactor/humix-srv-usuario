import request from 'supertest';
import { Server } from 'http';
import app from '../app';

describe('Servidor Express', () => {
  let server: Server;

  beforeAll((done) => {
    server = app.listen(4000, () => done());
  });

  afterAll((done) => {
    server.close(done); 
  });

  it('Deve responder com status 200 na rota "/"', async () => {
    const response = await request(server).get('/');
    expect(response.status).toBe(200);
    expect(response.text).toBe('Servidor no ar!');
  });
});