const router = require('express').Router();
const { z } = require('zod');
const ctrl = require('../controllers/authController');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');

const loginSchema = z
  .object({
    identifier: z.string().trim().min(1).optional(),
    username: z.string().trim().min(1).optional(),
    email: z.string().trim().min(1).optional(),
    password: z.string({ required_error: 'Password wajib diisi' }).min(1, 'Password wajib diisi'),
  })
  .refine((d) => d.identifier || d.username || d.email, {
    message: 'Username atau email wajib diisi',
    path: ['username'],
  });

const registerSchema = z.object({
  username: z
    .string({ required_error: 'Username wajib diisi' })
    .trim()
    .min(3, 'Username minimal 3 karakter')
    .max(50, 'Username maksimal 50 karakter')
    .regex(/^[a-zA-Z0-9_.]+$/, 'Username hanya boleh huruf, angka, titik, dan underscore'),
  email: z
    .string({ required_error: 'Email wajib diisi' })
    .trim()
    .toLowerCase()
    .email('Format email tidak valid')
    .max(100),
  password: z
    .string({ required_error: 'Password wajib diisi' })
    .min(6, 'Password minimal 6 karakter')
    .max(100),
});

router.post('/login', validate(loginSchema), ctrl.login);
router.post('/register', validate(registerSchema), ctrl.register);
router.get('/me', auth, ctrl.me);

module.exports = router;
