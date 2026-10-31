const db = require('../config/db');
const AppError = require('../utils/AppError');
const asyncHandler = require('../utils/asyncHandler');

const COLUMNS = 'id, nama_lengkap, jenis_kelamin, alamat, kelas, jurusan, nipd';

const findById = async (id) => {
  const [rows] = await db.query(`SELECT ${COLUMNS} FROM siswa WHERE id = ?`, [id]);
  return rows[0];
};

const assertNipdUnik = async (nipd, exceptId = null) => {
  if (!nipd) return;
  const [rows] = await db.query(
    'SELECT id FROM siswa WHERE nipd = ? AND id <> ? LIMIT 1',
    [nipd, exceptId || 0]
  );
  if (rows.length) throw new AppError('NIPD sudah dipakai siswa lain', 409);
};

// GET /api/siswa?page=1&limit=10&search=emre&kelas=XII&jurusan=RPL&sort_by=nama_lengkap&order=asc
exports.list = asyncHandler(async (req, res) => {
  const { page, limit, search, kelas, jurusan, jenis_kelamin, sort_by, order } = req.query;

  const where = [];
  const params = [];

  if (search) {
    where.push('(nama_lengkap LIKE ? OR nipd LIKE ? OR alamat LIKE ?)');
    const like = `%${search}%`;
    params.push(like, like, like);
  }
  if (kelas) { where.push('kelas = ?'); params.push(kelas); }
  if (jurusan) { where.push('jurusan = ?'); params.push(jurusan); }
  if (jenis_kelamin) { where.push('jenis_kelamin = ?'); params.push(jenis_kelamin); }

  const whereSql = where.length ? `WHERE ${where.join(' AND ')}` : '';

  const [[{ total }]] = await db.query(
    `SELECT COUNT(*) AS total FROM siswa ${whereSql}`,
    params
  );

  // sort_by & order sudah divalidasi (enum), aman dipakai langsung
  const [rows] = await db.query(
    `SELECT ${COLUMNS} FROM siswa ${whereSql}
     ORDER BY ${sort_by} ${order.toUpperCase()}
     LIMIT ? OFFSET ?`,
    [...params, limit, (page - 1) * limit]
  );

  res.json({
    success: true,
    data: rows,
    pagination: { page, limit, total, total_pages: Math.ceil(total / limit) },
  });
});

// GET /api/siswa/stats
exports.stats = asyncHandler(async (req, res) => {
  const [[{ total }]] = await db.query('SELECT COUNT(*) AS total FROM siswa');
  const [per_kelas] = await db.query(
    'SELECT kelas, COUNT(*) AS jumlah FROM siswa GROUP BY kelas ORDER BY kelas'
  );
  const [per_jurusan] = await db.query(
    'SELECT jurusan, COUNT(*) AS jumlah FROM siswa GROUP BY jurusan ORDER BY jurusan'
  );
  const [per_jenis_kelamin] = await db.query(
    'SELECT jenis_kelamin, COUNT(*) AS jumlah FROM siswa GROUP BY jenis_kelamin'
  );

  res.json({ success: true, data: { total, per_kelas, per_jurusan, per_jenis_kelamin } });
});

// GET /api/siswa/:id
exports.getById = asyncHandler(async (req, res) => {
  const siswa = await findById(req.params.id);
  if (!siswa) throw new AppError('Data siswa tidak ditemukan', 404);
  res.json({ success: true, data: siswa });
});

// POST /api/siswa
exports.create = asyncHandler(async (req, res) => {
  const { nama_lengkap, jenis_kelamin, alamat, kelas, jurusan, nipd = null } = req.body;
  await assertNipdUnik(nipd);

  const [result] = await db.query(
    `INSERT INTO siswa (nama_lengkap, jenis_kelamin, alamat, kelas, jurusan, nipd)
     VALUES (?, ?, ?, ?, ?, ?)`,
    [nama_lengkap, jenis_kelamin, alamat, kelas, jurusan, nipd]
  );

  res.status(201).json({
    success: true,
    message: 'Data siswa berhasil ditambahkan',
    data: await findById(result.insertId),
  });
});

// PUT /api/siswa/:id  dan  PATCH /api/siswa/:id
exports.update = asyncHandler(async (req, res) => {
  const { id } = req.params;
  if (!(await findById(id))) throw new AppError('Data siswa tidak ditemukan', 404);

  // key berasal dari hasil parse zod (whitelist), jadi aman dipakai sebagai nama kolom
  const fields = Object.keys(req.body);
  if (req.body.nipd !== undefined) await assertNipdUnik(req.body.nipd, id);

  const setSql = fields.map((f) => `${f} = ?`).join(', ');
  await db.query(`UPDATE siswa SET ${setSql} WHERE id = ?`, [
    ...fields.map((f) => req.body[f]),
    id,
  ]);

  res.json({
    success: true,
    message: 'Data siswa berhasil diperbarui',
    data: await findById(id),
  });
});

// DELETE /api/siswa/:id
exports.remove = asyncHandler(async (req, res) => {
  const [result] = await db.query('DELETE FROM siswa WHERE id = ?', [req.params.id]);
  if (!result.affectedRows) throw new AppError('Data siswa tidak ditemukan', 404);
  res.json({ success: true, message: 'Data siswa berhasil dihapus' });
});
