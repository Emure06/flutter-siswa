const jwt = require('jsonwebtoken');
const AppError = require('../utils/AppError');

module.exports = (req, res, next) => {
  const header = req.headers.authorization || '';
  const [scheme, token] = header.split(' ');

  if (scheme !== 'Bearer' || !token) {
    return next(new AppError('Token tidak ditemukan', 401));
  }

  try {
    req.user = jwt.verify(token, process.env.JWT_SECRET);
    next();
  } catch (err) {
    const msg =
      err.name === 'TokenExpiredError'
        ? 'Token sudah kedaluwarsa, silakan login ulang'
        : 'Token tidak valid';
    next(new AppError(msg, 401));
  }
};
