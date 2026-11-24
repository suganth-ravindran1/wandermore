# Trailblazer AI

AI-powered travel planner & budget companion (Flutter MVP).

## Features

- **Explore** — International / Domestic toggle, search any place, category chips, destination cards, trending, Surprise Me
- **Create Itinerary** — Destination, dates, travelers, travel style, budget, flexible must-visit places
- **Must-Visit** — Add/remove free-text places (supports unknown destinations)
- **AI Preview** — Mock AI generates day-wise plan + budget JSON
- **Itinerary Details** — Timeline UI with must-visit highlights & travel time
- **Budget** — Total, category breakdown, daily average
- **Map** — Mock route + day markers (no API key required)
- **Trip Summary** — Banner, details, book CTA

## Architecture

- Clean structure: `data` / `presentation` / `core`
- **Riverpod** state management
- **GoRouter** navigation
- Reusable widgets (cards, chips, timeline, budget, buttons)

## Run

```bash
flutter pub get
flutter run
```

## Flow

Landing → Explore → Search/Select → Create → Must-Visit → Generate → Preview → Details / Budget / Map / Summary
