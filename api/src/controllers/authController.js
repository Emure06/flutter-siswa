const crypto = require('crypto');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/db');
const AppError = require('../utils/AppError');
const asyncHandler = require('../utils/asyncHandler');

const signToken = (user) =>
  jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  });

const publicUser = (u) => ({ id: u.id, username: u.username, email: u.email });

const safeEqual = (a, b) => {
  const ba = Buffer.from(String(a));
  const bb = Buffer.from(String(b));
  return ba.length === bb.length && crypto.timingSafeEqual(ba, bb);
};

// POST /api/auth/login
exports.login = asyncHandler(async (req, res) => {
  const { identifier, username, email, password } = req.body;
  const id = identifier || username || email;

  const [rows] = await db.query(
    'SELECT * FROM `user` WHERE username = ? OR email = ? LIMIT 1',
    [id, id]
  );
  const user = rows[0];
  const gagal = new AppError('Username/email atau password salah', 401);
  if (!user) throw gagal;

  const isHashed = user.password.startsWith('$2');
  let valid;

  if (isHashed) {
    valid = await bcrypt.compare(password, user.password);
  } else {
    // Akun lama dengan password plaintext: cocokkan, lalu otomatis di-hash
    valid = safeEqual(password, user.password);
    if (valid) {
      const hash = await bcrypt.hash(password, 10);
      await db.query('UPDATE `user` SET password = ? WHERE id = ?', [hash, user.id]);
    }
  }

  if (!valid) throw gagal;

  res.json({
    success: true,
    message: 'Login berhasil',
    data: { token: signToken(user), user: publicUser(user) },
  });
});

// POST /api/auth/register
exports.register = asyncHandler(async (req, res) => {
  const { username, email, password } = req.body;
  const hash = await bcrypt.hash(password, 10);

  const [result] = await db.query(
    'INSERT INTO `user` (username, email, password) VALUES (?, ?, ?)',
    [username, email, hash]
  );

  const user = { id: result.insertId, username, email };
  res.status(201).json({
    success: true,
    message: 'Registrasi berhasil',
    data: { token: signToken(user), user },
  });
});

// GET /api/auth/me
exports.me = asyncHandler(async (req, res) => {
  const [rows] = await db.query(
    'SELECT id, username, email FROM `user` WHERE id = ?',
    [req.user.id]
  );
  if (!rows[0]) throw new AppError('User tidak ditemukan', 404);
  res.json({ success: true, data: rows[0] });
});
