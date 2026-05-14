# Export Folder

Run this command from the repository root to create the downloadable MOSPL project ZIP here:

```bash
./scripts/create_project_zip.sh
```

The generated archive path is:

```text
export/MOSPL_complete_project.zip
```

The ZIP is ignored by git because it is a generated binary artifact. Upload it as a release/workspace artifact when you need a downloadable file.
