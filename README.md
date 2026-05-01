# Portfolio Website MVP (Flutter Web + Firebase)

High-performance, storytelling-first developer portfolio template built with Flutter Web.

## Features

- Clean Architecture (Data/Domain/Presentation) with `flutter_bloc`
- Firebase integration:
  - Cloud Firestore (`projects`, `leads`)
  - Firebase Storage-ready media links (MP4/WebP/APK)
  - Firebase Analytics events for project expansion and APK downloads
- Responsive dark/minimalist layout with sticky nav + mobile drawer
- Hero, Projects, About timeline, Skills grid, Contact form
- Lazy video initialization via viewport visibility (`visibility_detector`)
- Media caching via `cached_network_image`
- SEO-oriented metadata and semantic headings for indexable content

## Firestore Schema

`projects/{id}`:

- `title`, `subtitle`, `description`
- `challenge`, `solution`, `impact`
- `techStack: List<String>`
- `videoUrl: String`
- `imageUrls: List<String>`
- `githubUrl`, `demoUrl`
- `apkData: { url, version, size, date }`

`leads/{autoId}`:

- `name`, `email`, `message`, `createdAt`, `rateLimitKey`

`lead_rate_limits/{rateLimitKey}`:

- `email`, `windowCount`, `bucket`, `bucketStartedAt`, `bucketExpiresAt`, `lastSentAt`, `updatedAt`

`portfolio/profile`:

- `name`, `role`, `summary`
- `location`, `email`, `phone`
- `resumeUrl`, `githubUrl`, `linkedInUrl`
- `contactIntro`
- `skills: List<String>`
- `aboutItems: List<{ title: String, body: String }>`

## Setup

1. Install dependencies:
   - `flutter pub get`
2. Configure Firebase:
   - Web is already configured for project `portfolio-ebb6c` in `lib/firebase_options.dart`.
   - If you add Android/iOS/Desktop later, run:
     - `flutterfire configure`
3. Run:
   - `flutter run -d chrome`

## Build (HTML renderer)

- `bash build_web.sh`

## Firebase Hosting

- Build web output goes to `build/web`
- Deploy with Firebase CLI:
  - `firebase login`
  - `firebase use portfolio-ebb6c`
  - `firebase deploy --only firestore:rules,firestore:indexes,storage`
  - `firebase deploy --only hosting`

## Firebase Console Checklist

1. Firestore Database:
   - Create database in **production mode**.
   - Region: choose the closest location to your users.
   - Create collection `projects` and add docs using schema above.
   - Create document `portfolio/profile` for hero/about/skills/contact content.
2. Storage:
   - Enable Firebase Storage.
   - Upload project media under `projects/...` and APK files under `downloads/...`.
3. Analytics:
   - Ensure Google Analytics is enabled for the project (already referenced via `measurementId`).
4. Contact leads:
   - `leads` collection will be created automatically when users submit the form.
5. Rules deploy:
   - Rules files are included in repo:
     - `firestore.rules`
     - `storage.rules`
   - If you see `permission-denied` in contact form, redeploy Firestore rules:
     - `firebase deploy --only firestore:rules`
# Portfolio
