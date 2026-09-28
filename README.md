# Nyetam

Nyetam is a Flutter tourism and exploration application designed around three questions: Where am I? What is around me? How do I get there?

## Current mobile experience

- Nearby discovery with search and category filters
- 67 searchable Yaoundé destinations across all six place categories
- Interactive city shortcuts for quickly filtering destination catalogs
- Complete 10-region browser with regional destination and category filters
- First-run welcome and transparent location-consent flow
- Functional sign-in and account creation with validation and clear errors
- Google Sign-In with backend-verified Google ID tokens
- Secure JWT storage and authenticated session restoration
- Real Android, iOS and web GPS access through an abstract location service
- Cameroon city and regional exploration
- Interactive, zoomable map with selectable service markers
- Coordinate-projected Cameroon map with regional labels and route overlays
- Place details with ratings, practical information, coordinates, fees and travel time
- Cameroon event discovery with dates, venues, organizers and ticket details
- Add and remove events from the personal trip itinerary
- Verified traveler reviews with calculated averages and moderation reporting
- Five-star review composer with validation and live rating updates
- Cultural guide covering cuisine, customs, languages, history and arts
- Topic and regional guide filters with detailed reading pages
- Favorites and personal itinerary state
- Numbered itinerary trace with per-leg and total distance estimates
- Emergency coordinates and location sharing surface
- Responsive Android, iOS and web layouts

Listings and map tiles currently use local demo adapters so the interface runs without API keys. Device coordinates use the platform GPS API. Production adapters can connect the existing abstractions to FastAPI, Mapbox or Google Maps, and offline storage.

## Backend

The `backend` directory provides:

- Tourist registration and login
- Argon2 password hashing
- Signed JWT access tokens
- Authenticated `/api/v1/users/me` endpoint
- Role-ready SQLAlchemy user model
- SQLite development storage and PostgreSQL/PostGIS configuration support
- OpenAPI documentation and isolated pytest coverage

## Architecture and patterns

The project uses a lightweight layered architecture:

- `domain`: immutable entities and value objects
- `data`: repository contracts and data-source implementations
- `presentation`: controllers, screens and reusable widgets

Applied OOP principles and patterns:

- **Encapsulation:** `ExploreController` owns mutable favorite, filter and itinerary state and exposes read-only views.
- **Abstraction:** `PlaceRepository` defines the data contract without coupling the UI to REST, SQL or local storage.
- **Polymorphism:** any repository implementation can replace `DemoPlaceRepository` through the shared interface.
- **Inheritance:** `Place` and `TripPlan` specialize the shared `TourismEntity` abstraction.
- **Repository pattern:** tourism data access is isolated from application state and widgets.
- **Observer pattern:** Flutter `ChangeNotifier` updates subscribed views when domain state changes.
- **Dependency injection:** the repository is supplied to the controller and the controller to the application root.

See [docs/architecture.md](docs/architecture.md) for component boundaries, security decisions, diagrams, and pattern rationale.

## CI/CD

GitHub Actions provides two pipelines:

- **CI:** formatting, Flutter analysis, Flutter tests, FastAPI tests, web build, and debug APK build on every push and pull request to `main`.
- **Delivery:** after successful CI on `main`, deploys Flutter web to GitHub Pages and publishes the FastAPI container to `ghcr.io/vanbrown99/nav-app-api` with `latest` and commit-SHA tags.

Configure these GitHub repository variables before production delivery:

- `API_BASE_URL`: deployed FastAPI URL
- `GOOGLE_WEB_CLIENT_ID`: Google Web OAuth client ID
- `GOOGLE_MAPS_WEB_API_KEY`: browser-restricted Maps key
- `GOOGLE_MAPS_ENABLED`: `true` after the Maps key is configured

In repository **Settings → Pages**, select **GitHub Actions** as the source. The backend image still needs a runtime host such as Cloud Run, Fly.io, Render, or a container server; GHCR is the deployable artifact registry, not the running service.

## Visual system

The palette is based on Cameroon’s forests, coastal landscapes and warm natural materials:

- Forest green: `#0B5D3B`
- Canopy green: `#217A4B`
- Moss: `#B7C9A8`
- Gold: `#D5A62D`
- Clay: `#C76D40`
- Mineral cream: `#F7F5ED`
- Deep ink: `#173129`

Playfair Display provides destination-led editorial headings, while DM Sans keeps navigation and operational information clear.

## Run

```sh
flutter pub get
flutter run
```

Start the FastAPI backend first:

```powershell
Set-Location backend
..\.venv\Scripts\python -m uvicorn app.main:app --reload
```

The Flutter app uses `http://127.0.0.1:8000` on web/desktop and `http://10.0.2.2:8000` on the Android emulator. For a physical device or deployed API, pass the reachable backend URL:

```sh
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8000
```

API documentation is available at `http://127.0.0.1:8000/docs`.

### Google Sign-In setup

1. Create a Web OAuth client in Google Cloud Console. Add `http://localhost` and `http://localhost:8123` as authorized JavaScript origins.
2. Set the same Web client ID as `GOOGLE_CLIENT_ID` in `backend/.env`.
3. Run Flutter web with:

```sh
flutter run -d chrome --web-port 8123 --dart-define=GOOGLE_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

For Android, create an Android OAuth client for package `cm.nyetam.nyetam` and the app signing SHA-1, then pass the Web client ID as `GOOGLE_SERVER_CLIENT_ID`.

For iOS, create an iOS OAuth client for the app bundle identifier, configure its reversed client ID URL scheme in `ios/Runner/Info.plist`, and pass both the iOS client ID and Web server client ID:

```sh
flutter run --dart-define=GOOGLE_CLIENT_ID=your-ios-client-id.apps.googleusercontent.com --dart-define=GOOGLE_SERVER_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

### Google Maps setup

Enable **Maps SDK for Android**, **Maps SDK for iOS**, and **Maps JavaScript API** in Google Cloud. Use a separate restricted key for each platform.

Enable **Routes API** for road-following itinerary traces. Store its server-restricted key only in `backend/.env`:

```text
GOOGLE_ROUTES_API_KEY=your-server-restricted-routes-key
```

Never expose the Routes server key through Flutter or `web/index.html`.

Android reads its key from the process environment and enables the Google map through a Dart define:

```powershell
$env:GOOGLE_MAPS_API_KEY = "your-android-restricted-key"
flutter run --dart-define=GOOGLE_MAPS_CONFIGURED=true
```

Restrict the Android key to package `cm.nyetam.nyetam` and the signing certificate SHA-1.

For iOS, define `GOOGLE_MAPS_API_KEY` as a user-defined Xcode build setting and run with `--dart-define=GOOGLE_MAPS_CONFIGURED=true`. Restrict that key to the iOS bundle identifier.

For web, place the web-restricted key in the `google-maps-api-key` meta tag in `web/index.html`, authorize the site origin, and run:

```sh
flutter run -d chrome --web-port 8123 --dart-define=GOOGLE_MAPS_CONFIGURED=true --dart-define=GOOGLE_CLIENT_ID=your-web-client-id.apps.googleusercontent.com
```

Without these credentials, Nyetam intentionally uses its built-in Cameroon map and displays a clear Google Sign-In configuration error. API keys and OAuth client IDs are not committed to source control.

## Validate

```sh
flutter analyze
flutter test
```
