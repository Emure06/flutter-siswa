const router = require('express').Router();
const { z } = require('zod');
const ctrl = require('../controllers/siswaController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const teks = (label, max) =>
  z
    .string({ required_error: `${label} wajib diisi`, invalid_type_error: `${label} harus berupa teks` })
    .trim()
    .min(1, `${label} wajib diisi`)
    .max(max, `${label} maksimal ${max} karakter`);

const createSchema = z.object({
  nama_lengkap: teks('Nama lengkap', 100),
  jenis_kelamin: z.enum(['Laki-laki', 'Perempuan'], {
    errorMap: () => ({ message: "Jenis kelamin harus 'Laki-laki' atau 'Perempuan'" }),
  }),
  alamat: teks('Alamat', 5000),
  kelas: teks('Kelas', 20),
  jurusan: teks('Jurusan', 50),
  nipd: z
    .string()
    .trim()
    .max(50, 'NIPD maksimal 50 karakter')
    .transform((v) => (v === '' ? null : v))
    .nullable()
    .optional(),
});

const patchSchema = createSchema
  .partial()
  .refine((o) => Object.keys(o).length > 0, { message: 'Minimal satu field harus diisi' });

const idSchema = z.object({
  id: z.coerce.number({ invalid_type_error: 'ID harus angka' }).int().positive(),
});

const listSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(10),
  search: z.string().trim().optional(),
  kelas: z.string().trim().optional(),
  jurusan: z.string().trim().optional(),
  jenis_kelamin: z.enum(['Laki-laki', 'Perempuan']).optional(),
  sort_by: z.enum(['id', 'nama_lengkap', 'kelas', 'jurusan', 'nipd']).default('id'),
  order: z.enum(['asc', 'desc']).default('asc'),
});

router.use(auth); // semua endpoint siswa butuh login

router.get('/', validate(listSchema, 'query'), ctrl.list);
router.get('/stats', ctrl.stats); // harus di atas '/:id'
router.get('/:id', validate(idSchema, 'params'), ctrl.getById);
router.post('/', validate(createSchema), ctrl.create);
router.put('/:id', validate(idSchema, 'params'), validate(createSchema), ctrl.update);
router.patch('/:id', validate(idSchema, 'params'), validate(patchSchema), ctrl.update);
router.delete('/:id', validate(idSchema, 'params'), ctrl.remove);

module.exports = router;
