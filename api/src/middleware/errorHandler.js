const notFound = (req, res) => {
  res.status(404).json({
    success: false,
    message: `Endpoint ${req.method} ${req.originalUrl} tidak ditemukan`,
  });
};

const errorHandler = (err, req, res, next) => {
  let status = err.statusCode || 500;
  let message = err.message || 'Terjadi kesalahan pada server';

  if (err.type === 'entity.parse.failed') {
    status = 400;
    message = 'Format JSON tidak valid';
  } else if (err.code === 'ER_DUP_ENTRY') {
    status = 409;
    const sql = err.sqlMessage || '';
    if (sql.includes('username')) message = 'Username sudah dipakai';
    else if (sql.includes('email')) message = 'Email sudah dipakai';
    else message = 'Data sudah ada (duplikat)';
  }

  if (status >= 500) {
    console.error(err);
    if (process.env.NODE_ENV === 'production') {
      message = 'Terjadi kesalahan pada server';
    }
  }

  res.status(status).json({
    success: false,
    message,
    ...(err.details && { errors: err.details }),
  });
};

module.exports = { notFound, errorHandler };
