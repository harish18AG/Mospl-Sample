MOSPL Complete Project ZIP

Binary ZIP files are intentionally not committed to this PR because GitHub pull requests do not provide useful reviews for generated binary archives.

To create the downloadable archive locally or in the workspace, run from the repository root:

  ./scripts/create_project_zip.sh

The generated file will be:

  export/MOSPL_complete_project.zip

Android Studio quick start after extracting the generated ZIP:
1. Open the extracted project folder in Android Studio.
2. If Android platform files are not present in your extracted copy, run: flutter create --platforms=android .
3. Run: flutter pub get
4. Configure Firebase: flutterfire configure
5. Start backend: cd backend && cp .env.example .env && npm install && npm run dev
6. Run Flutter with: flutter run --dart-define=MOSPL_API_BASE_URL=http://10.0.2.2:5000/api

See docs/setup_guide.md and backend/README.md for full setup instructions.
See final/ZIP_MANIFEST.md for archive generation and verification commands.
