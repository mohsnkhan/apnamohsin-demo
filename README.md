# NovaByte Technologies — Company Website & API

A premium, fully responsive software development company website with a complete
backend: **React 19 + Vite + Tailwind CSS** on the front end, **Node.js +
Express 5 + MongoDB + Mongoose** on the back end.

---

## 1. What's included

### Front end

- Dark navy / black theme, blue → indigo → violet gradients
- Sora + Inter typography, glassmorphism cards, gradient buttons
- Scroll-reveal animations, animated hero, marquee, scroll progress bar
- Responsive from 320 px phones to ultra-wide desktops
- `prefers-reduced-motion` support and visible keyboard focus states

| Section | Highlights |
| --- | --- |
| Home | Animated hero, floating product mockup, dual CTAs |
| About Us | Intro, mission, vision, six reasons to choose NovaByte |
| Services | 9 service cards that preselect the contact form |
| Portfolio | 6 CSS-built demo concepts, filters, detail modal |
| Technologies | Grouped stack cards + infinite marquee |
| Pricing | Starter / Professional / Enterprise — “Contact for Pricing” |
| Testimonials | Clearly labelled sample content |
| Contact | Validated form wired to the real API |

### Back end

- **Contact API** — validated, rate-limited, spam-protected, stored in MongoDB
- **Services API** — list all / fetch one (slug or id)
- **Portfolio API** — list with filters, categories, fetch one
- **Admin API** — bcrypt password hashing, JWT login, httpOnly cookie, protected enquiry management
- **Security** — Helmet, CORS allow-list, rate limiting, NoSQL-injection sanitising, strict validation, central error handling
- **Seeding** — services, portfolio and the first admin account
- **Testing** — end-to-end API suite on an in-memory MongoDB

Full backend documentation: [`server/README.md`](server/README.md).

---

## 2. Requirements

- **Node.js 22.12+** (tested on Node 24)
- **npm 10+**
- **MongoDB 6+** — local install, Docker, or [MongoDB Atlas](https://www.mongodb.com/atlas)

> Windows PowerShell: if `npm` is blocked by the execution policy, use `npm.cmd`.

---

## 3. Quick start

```bash
# 1. Install client + server (npm workspaces)
npm install

# 2. Create environment files
copy client\.env.example client\.env     # Windows
copy server\.env.example server\.env     # Windows
# cp client/.env.example client/.env && cp server/.env.example server/.env   # macOS/Linux

# 3. Edit server/.env
#    - MONGODB_URI   (mongodb://127.0.0.1:27017/novabyte or your Atlas URI)
#    - JWT_SECRET    (32+ random characters)
#    - ADMIN_EMAIL / ADMIN_PASSWORD (first admin account)

# 4. Run API + front end together
npm run dev
```

- Front end → http://localhost:5173
- API → http://localhost:5000
- Health → http://localhost:5000/api/health
- Admin data is seeded automatically on first boot (`SEED_ON_START=true`).

### Generate a JWT secret

```bash
node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"
```

---

## 4. Contact form flow

1. The form validates every field client-side (on blur and on submit).
2. `POST /api/contact` is sent through the Vite proxy in development.
3. The server sanitises the body, re-validates it, checks the honeypot and rate limit.
4. The enquiry is saved to MongoDB (collection `contacts`) with a reference like `NB-MX3K9A1B7`.
5. The UI shows a success panel with that reference, or precise field errors from the API.
6. If the API is unreachable, the form offers a `mailto:` fallback.

Enquiries are readable only through protected admin endpoints.

---

## 5. Admin API

```bash
# Sign in (also sets the nb_admin_session httpOnly cookie)
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@novabytetechnologies.com","password":"YOUR_PASSWORD"}'

# List enquiries
curl http://localhost:5000/api/admin/inquiries \
  -H "Authorization: Bearer <TOKEN>"
```

5 failed logins lock the account for 15 minutes; logins are rate-limited per IP.
See `server/README.md` for the full endpoint reference.

---

## 6. Production

```bash
npm run build     # builds client/dist
npm start         # Express serves the API + the built SPA on :5000
```

Open http://localhost:5000 — one origin, no proxy needed.

Before deploying:

1. `NODE_ENV=production`
2. Strong `JWT_SECRET`, real `MONGODB_URI`
3. `COOKIE_SECURE=true` and HTTPS
4. `ALLOW_FILE_FALLBACK=false`
5. `CORS_ORIGIN=https://your-domain.com`
6. Use a process manager (PM2, systemd, Docker) and a reverse proxy (Nginx, Caddy)

---

## 7. Project structure

```
.
├── package.json                 # workspace root: dev / build / start / seed / test
├── client/
│   ├── index.html               # SEO meta, fonts, JSON-LD
│   ├── public/                  # favicon, OG image, robots.txt, manifest
│   ├── tailwind.config.js
│   └── src/
│       ├── App.jsx
│       ├── config/site.js       # company details + WhatsApp config
│       ├── data/                # fallback content for the UI
│       ├── lib/api.js           # API client (contact submission)
│       ├── components/          # Navbar, Hero, sections, Footer
│       └── utils/
└── server/
    ├── server.js                # entry point
    ├── .env.example
    ├── scripts/test-api.mjs     # integration suite
    ├── data/                    # dev-only JSON fallback (git-ignored)
    └── src/
        ├── app.js               # Express app
        ├── config/              # env, database, service allow-list
        ├── models/              # Contact, Service, PortfolioProject, Admin
        ├── controllers/
        ├── routes/
        ├── repositories/
        ├── middleware/          # auth, validation, rate limits, error handler
        ├── validators/
        ├── data/seedData.js
        └── utils/
```

---

## 8. Environment variables

### `client/.env`

| Variable | Purpose |
| --- | --- |
| `VITE_WHATSAPP_NUMBER` | Digits-only international WhatsApp number. Empty disables deep links and shows a setup hint. |
| `VITE_CONTACT_EMAIL` | Public email shown in the footer/contact section |
| `VITE_CONTACT_PHONE_DISPLAY` / `VITE_CONTACT_PHONE_HREF` | Optional phone display + `tel:` link |
| `VITE_SOCIAL_*` | Optional social URLs (icons render only when set) |
| `VITE_API_URL` | Only needed when the API is on a different origin |

### `server/.env`

See [`server/.env.example`](server/.env.example) and the table in
[`server/README.md`](server/README.md). Key values: `MONGODB_URI`,
`JWT_SECRET`, `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `CORS_ORIGIN`.

Only variables prefixed with `VITE_` reach the browser. Database credentials and
`JWT_SECRET` never leave the server.

---

## 9. Seeding

```bash
npm run seed
```

Inserts the 9 services, 6 portfolio concepts, and the admin account if missing.
It uses `$setOnInsert`, so existing records are never overwritten. Seeding also
runs automatically at startup when `SEED_ON_START=true`.

---

## 10. Testing

```bash
npm run test:api
```

Starts an in-memory MongoDB, seeds it, boots the API and exercises every
endpoint: health, services, portfolio, contact validation/storage/honeypot,
login (wrong + correct), cookie and Bearer auth, protected enquiry list, update,
stats, delete, logout and 404 handling.

> The first run downloads a MongoDB test binary. If downloads are blocked in your
> environment, point `MONGOMS_SYSTEM_BINARY` at an existing `mongod` executable.

---

## 11. Customising

| Want to change… | Edit |
| --- | --- |
| Company name, email, tagline | `client/src/config/site.js` |
| Navigation labels/order | `NAV_LINKS` in `client/src/config/site.js` |
| Services (UI) | `client/src/data/services.js` |
| Services (API + validation) | `server/src/data/seedData.js` |
| Portfolio demos | `client/src/data/portfolio.js` + `server/src/data/seedData.js` |
| Pricing tiers | `client/src/data/pricing.js` |
| Colours / gradients | `client/tailwind.config.js`, `client/src/index.css` |
| SEO / meta | `client/index.html` |
| API security | `server/src/app.js`, `server/src/middleware/` |

---

## 12. Content honesty

These choices are deliberate, not placeholders:

- **Portfolio projects are demonstration concepts**, badged “Demo Concept”.
- **No invented company history, clients, awards or metrics.**
- **No fake prices** — all tiers say “Contact for Pricing”.
- **Testimonials are labelled samples** with a visible disclaimer.

Replace them with real, verifiable content when available.

---

## 13. Troubleshooting

| Issue | Fix |
| --- | --- |
| `npm` blocked in PowerShell | Use `npm.cmd …` or `Set-ExecutionPolicy -Scope Process Bypass` |
| API says “MongoDB is not set” | Set `MONGODB_URI` in `server/.env` and restart |
| Production exits immediately | MongoDB is required in production — check `MONGODB_URI` |
| `JWT_SECRET` error on boot | Add a 32+ character secret to `server/.env` |
| Admin login fails | Check `ADMIN_EMAIL` / `ADMIN_PASSWORD`, then run `npm run seed` |
| Port 5000 in use | Change `PORT` in `server/.env` and `API_PROXY_TARGET` for Vite |
| Contact form says unavailable | Start the API and check `/api/health` |
| WhatsApp button shows a notice | Set `VITE_WHATSAPP_NUMBER` and restart Vite |
| Fonts differ offline | Google Fonts is remote; a system font stack is used as fallback |
