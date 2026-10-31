require('dotenv').config();

if (!process.env.JWT_SECRET) {
  console.error('JWT_SECRET belum diisi di file .env');
  process.exit(1);
}

const app = require('./app');
const db = require('./config/db');

const PORT = Number(process.env.PORT) || 3000;

(async () => {
  try {
    await db.query('SELECT 1');
    console.log('Terhubung ke database MySQL');
  } catch (err) {
    console.error('Gagal konek ke database:', err.message);
    process.exit(1);
  }

  // 0.0.0.0 supaya bisa diakses emulator / HP lewat IP LAN
  const server = app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server jalan di http://localhost:${PORT}`);
  });

  const shutdown = () => {
    server.close(async () => {
      await db.end();
      process.exit(0);
    });
  };
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);
})();
