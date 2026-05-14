# MOSPL ZIP Manifest

Generated ZIP archives are intentionally **not committed** to git because they are binary build artifacts and GitHub pull requests cannot show useful diffs for them.

Generate the archive from the repository root:

```bash
./scripts/create_project_zip.sh
```

Default generated archive path:

- `export/MOSPL_complete_project.zip`

Verification commands:

```bash
zip -T export/MOSPL_complete_project.zip
unzip -l export/MOSPL_complete_project.zip | grep -E '(^| )(backend/src/app.js|pubspec.yaml|docs/setup_guide.md|firebase/firestore.rules)$'
sha256sum export/MOSPL_complete_project.zip
```

If you need to share the ZIP, upload the generated `export/MOSPL_complete_project.zip` as a GitHub Release asset, workflow artifact, or workspace download artifact instead of adding it to a pull request.
