# Mohsin Mountain

A React + Vite website for **Mohsin Mountain**, a mountain travel agency with a fleet of
**50 red MOHSIN BUS coaches**, weekly departures on eight mountain routes, and private
bus rental for families, weddings, schools and companies.

## What is inside

- **Hero** with a hand-drawn dawn landscape, floating bus card and live-fleet badge.
- **Red bus marquee** — the whole fleet, always driving past.
- **Fleet section** — all 50 buses, searchable and filterable by route and availability,
  with seats, driver, year and day rate. "Show more" pages through the fleet.
- **Eight mountain routes** with scenic artwork, duration, fare and one-click booking.
- **Private rental calculator** — pick a package, coaches and days; totals and multi-day
  discounts update instantly.
- **Booking modal** — validation, live fare estimate, optional bus selection, and a
  confirmation ticket with a booking reference. Rental requests use the same flow.
- **Testimonials, safety features, CTA, contact footer** and a sticky mobile book bar.
- Fully responsive, keyboard accessible, reduced-motion friendly, no external images
  (all scenery and buses are inline SVG, so the design always loads).

## Run it

```bash
npm install
npm run dev
```

Open the printed local URL (default `http://localhost:5173`).

```bash
npm run build     # production build in dist/
npm run preview   # preview the production build
```

## Make it yours

Most content lives in one place — `src/data.js`:

| Export | What it controls |
| --- | --- |
| `ROUTES` | Route names, regions, durations, fares, blurb, artwork tone |
| `BUSES` | Generated 50-bus fleet: number, plate, seats, status, driver, rate |
| `RENT_PACKAGES` | Rental packages and daily rates |
| `TESTIMONIALS` | Traveller stories |
| `STATS` | Headline numbers |
| `PHONE`, `EMAIL` | Contact details used across the site |

The red bus livery artwork is in `src/components/BusArt.jsx`; the mountain scenery is in
`src/components/MountainArt.jsx`. Colours, spacing and responsive rules are defined with
CSS variables at the top of `src/styles.css`.

## Project structure

```
index.html
src/
  main.jsx
  App.jsx
  styles.css
  data.js
  components/
    Navbar.jsx   Hero.jsx      Marquee.jsx   Stats.jsx
    Fleet.jsx    Routes.jsx    Rent.jsx      Why.jsx
    Testimonials.jsx          Footer.jsx    Booking.jsx
    BusArt.jsx   MountainArt.jsx            Icon.jsx
    Reveal.jsx
```

## Notes

- Bookings are front-end only: the form validates and shows a confirmation, but does not
  send data anywhere. Connect `onSubmit` in `src/components/Booking.jsx` to your API,
  email service or booking system.
- All fares, bus statuses and phone numbers are sample data — update them in `src/data.js`.
