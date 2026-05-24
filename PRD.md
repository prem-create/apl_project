# Product Requirements Document
## IPL Fan Portfolio — Season 2026

**Version:** 1.0  
**Date:** May 2026  
**Status:** In Development

---

## 1. Overview

### 1.1 Product Summary

IPL Fan Portfolio is a Flutter web application that lets cricket fans create, personalise, and share a public profile page celebrating their IPL fandom. Each fan answers a short set of questions, gets an AI-generated avatar powered by Gemini 2.0, and receives a unique shareable link to their portfolio.

### 1.2 Problem Statement

IPL fans are deeply passionate but have no dedicated space to express and share their fandom identity. Social media profiles are generic. This product gives every fan a personalised, beautiful portfolio page — built in minutes — that they can share with friends, family, and fellow fans.

### 1.3 Goals

- Let any fan build a portfolio in under 3 minutes
- Make every portfolio publicly accessible via a unique URL
- Generate a personalised AI avatar for each fan automatically
- Display all fan portfolios on a discoverable landing page
- Be fully responsive and production-ready for web hosting

---

## 2. Users

### 2.1 Primary User

**The IPL Fan**
- Age: 16–45
- Watches IPL every season
- Active on social media, shares cricket content
- Wants to express team loyalty and cricket identity
- Not necessarily technical

### 2.2 Secondary User

**The Visitor / Friend**
- Receives a shared portfolio link
- Views a fan's profile without needing to sign in
- May be inspired to create their own portfolio

---

## 3. Pages & Features

### 3.1 Page 1 — Landing Page (`/`)

**Purpose:** Showcase all fan portfolios and drive new sign-ups.

| Feature | Description |
|---|---|
| Hero section | Animated headline with word-by-word blur-in, IPL 2026 badge, subheading |
| Build CTA | Prominent "Build Your Portfolio" button linking to `/create` |
| Fan grid | Live grid of all fan portfolio cards, streamed from Firestore |
| Profile card | Shows fan name, handle, city, team badge, bio preview, team accent colour |
| Empty state | Friendly prompt when no portfolios exist yet |
| Shimmer loading | Skeleton cards while Firestore data loads |
| Navbar | Logo, "Build Your Portfolio" shortcut, trophy icon |
| Animated background | Floating colour orbs that pulse and drift |
| Footer | Minimal branding |
| Responsive | 2-column mobile, 3-column tablet, 4-column desktop |

### 3.2 Page 2 — Create Page (`/create`)

**Purpose:** Authenticate the user and collect their fan profile data.

#### Auth Step

| Feature | Description |
|---|---|
| Email sign in | Email + password login with validation |
| Email register | New account creation with confirm password |
| Forgot password | Sends Firebase reset email |
| Google sign in | One-tap Google OAuth |
| Tab UI | Sign In / Register tabs with animated indicator |
| Error handling | Human-readable messages for all Firebase error codes |

#### Form Step (shown after auth)

| Feature | Description |
|---|---|
| Photo upload | Optional — gallery or camera, stored in Firebase Storage |
| Full name | Required text field |
| Username / handle | Required, alphanumeric + underscore, min 3 chars |
| City | Required text field |
| Favourite team | Visual pill picker — all 10 IPL teams with team colours |
| Favourite player | Required text field |
| Fan bio | Required, min 20 characters, multi-line |
| Watch style | "How do you watch matches?" — feeds Gemini prompt |
| Match mood | "Your mood when your team wins?" — feeds Gemini prompt |
| Validation | All fields validated before submission |
| Submit button | Gold gradient "Create My Portfolio" button |

#### Generating State

| Feature | Description |
|---|---|
| Overlay screen | Full-screen animated pulsing orb while Gemini generates |
| Status messages | "Generating your AI avatar..." → "Saving your portfolio..." |
| Non-blocking AI | If Gemini fails, portfolio is still created without avatar |

#### On Success

- Profile written to Firestore `fan_profiles` collection
- User redirected to `/portfolio/:id`

### 3.3 Page 3 — Portfolio Page (`/portfolio/:id`)

**Purpose:** The fan's public profile — shareable with anyone.

| Feature | Description |
|---|---|
| Avatar display | AI-generated Gemini image, or photo upload, or placeholder |
| Team badge | Coloured pill showing favourite team with team accent colour |
| Fan name | Large italic heading with blur-in animation |
| Handle + city | Shown below name |
| Bio | Displayed in a glass card |
| Info cards | Favourite player, team, city, fan-since year |
| Shareable link | Copyable URL with animated copy/check icon |
| Back navigation | Returns to landing page |
| Loading state | Spinner while profile loads from Firestore |
| Not found state | Friendly message if profile ID is invalid |
| Responsive | Stacked on mobile, side-by-side on desktop |

---

## 4. Data Model

### `fan_profiles` (Firestore collection)

| Field | Type | Description |
|---|---|---|
| `ownerUid` | string | Firebase Auth UID of creator |
| `name` | string | Fan's full name |
| `handle` | string | Unique username |
| `city` | string | Fan's city |
| `favouriteTeam` | string | IPL team code (e.g. "MI") |
| `favouritePlayer` | string | Favourite player name |
| `bio` | string | Fan bio text |
| `photoUrl` | string | Firebase Storage URL (optional) |
| `aiImageUrl` | string | Gemini-generated avatar Storage URL (optional) |
| `watchStyle` | string | Answer to watch style question |
| `matchMood` | string | Answer to match mood question |
| `createdAt` | int | Unix timestamp (milliseconds) |

---

## 5. Authentication

| Method | Provider |
|---|---|
| Email / Password | Firebase Auth |
| Google OAuth | Firebase Auth + google_sign_in |

- Auth is required only to **create** a portfolio
- Viewing any portfolio is fully public — no sign-in needed
- Only the profile owner can create (write); all reads are open

---

## 6. AI Avatar Generation

- **Model:** Gemini 2.0 Flash (image generation)
- **Trigger:** On form submission, before Firestore write
- **Prompt inputs:** name, city, favourite team, favourite player, watch style, match mood
- **Output:** PNG image bytes → uploaded to Firebase Storage → URL stored in profile
- **Failure handling:** If generation fails, portfolio is created without an avatar — no error shown to user

---

## 7. Design System

### Colours

| Token | Hex | Usage |
|---|---|---|
| `kBg` | `#05060F` | Page background |
| `kSurface` | `#0D0F1E` | Card surfaces |
| `kGold` | `#D4AF37` | Primary accent, CTAs |
| `kGoldLight` | `#FFD966` | Button gradients |
| `kBlue` | `#1A6FFF` | Secondary accent |
| `kRed` | `#D4001A` | Tertiary accent |

### Typography

| Role | Font | Style |
|---|---|---|
| Headings | Playfair Display | Italic, Bold |
| Body | Barlow | Light / Regular / SemiBold |
| Labels | Barlow | SemiBold, tracked |

### Components

- **LiquidGlass** — backdrop blur + gradient border, used for all cards, chips, nav
- **LiquidGlassStrong** — heavier blur variant for primary CTAs
- **BlurText** — word-by-word blur-in animation (blur 10→0, opacity 0→1, y 50→0)
- **FadeIn** — opacity + translate-Y entrance with configurable delay

### Team Accent Colours

| Team | Colour |
|---|---|
| MI | `#004BA0` |
| CSK | `#FFCC00` |
| RCB | `#D4001A` |
| KKR | `#3A225D` |
| SRH | `#FF6B00` |
| DC | `#0078BC` |
| GT | `#1C4B9C` |
| LSG | `#00B4D8` |
| PBKS | `#ED1B24` |
| RR | `#FF69B4` |

---

## 8. Routing

| Path | Page | Auth required |
|---|---|---|
| `/` | Landing — fan grid | No |
| `/create` | Create portfolio | Yes (prompted inline) |
| `/portfolio/:id` | Public fan profile | No |

Router: `go_router` with hash-based URLs for static hosting compatibility.

---

## 9. Non-Functional Requirements

| Requirement | Detail |
|---|---|
| Responsive | Mobile (360px+), tablet (700px+), desktop (1100px+) |
| Performance | Firestore stream for real-time updates, shimmer loading states |
| Hosting | Static web build — compatible with GitHub Pages, Firebase Hosting, Netlify |
| Security | Firestore rules restrict writes to valid profile shape; reads are public |
| Accessibility | Sufficient colour contrast on all text; keyboard-navigable form fields |

---

## 10. Out of Scope (v1)

- Profile editing after creation
- Comments or reactions on portfolios
- Search or filter on the landing grid
- Native mobile app (Android / iOS)
- Admin dashboard

---

## 11. Dependencies

| Package | Version | Purpose |
|---|---|---|
| `firebase_core` | ^3.6.0 | Firebase initialisation |
| `cloud_firestore` | ^5.4.4 | Profile storage and streaming |
| `firebase_auth` | ^5.3.1 | Authentication |
| `firebase_storage` | ^12.3.2 | Photo and avatar storage |
| `google_sign_in` | ^6.2.1 | Google OAuth |
| `go_router` | ^14.2.7 | Client-side routing |
| `google_fonts` | ^6.2.1 | Playfair Display + Barlow |
| `image_picker` | ^1.1.2 | Photo upload |
| `http` | ^1.2.2 | Gemini API calls |

---

## 12. Deployment Checklist

- [ ] Firestore database created (test mode)
- [ ] Firestore security rules published
- [ ] Firebase Auth — Email/Password enabled
- [ ] Firebase Auth — Google sign-in enabled
- [ ] Firebase Storage bucket initialised
- [ ] Gemini API key set in `gemini_service.dart`
- [ ] `flutter build web --release` passes
- [ ] Deployed domain added to Firebase Auth authorised domains
