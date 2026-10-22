#!/usr/bin/env bash
set -euo pipefail
MOD_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE_ROOT="$(cd "$MOD_DIR/../../.." && pwd)"
cd "$MOD_DIR"
MOD_ID="gmarcs_gen2_celebi_time_travel"
VERSION="${1:-}"
if [ -z "$VERSION" ]; then
  OVERRIDE=$(git log -1 --pretty=%B | grep -oE '\[release [0-9]+\.[0-9]+\.[0-9]+\]' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)
  if [ -n "$OVERRIDE" ]; then VERSION="$OVERRIDE"
  else
    MANIFEST_VERSION=$(python3 -c "import json;print(json.load(open('manifest.json'))['version'])")
    if [[ "$MANIFEST_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then VERSION="$MANIFEST_VERSION"
    else VERSION="0.0.14"; fi
  fi
fi
TAG="v$VERSION"
echo "Releasing $VERSION (tag $TAG)"
if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null 2>&1; then echo "error: tag exists" >&2; exit 1; fi
python3 - "$MOD_DIR/manifest.json" "$VERSION" <<'PY'
import json, sys
path, version = sys.argv[1], sys.argv[2]
with open(path, encoding="utf-8") as fh: manifest = json.load(fh)
manifest["version"] = version
with open(path, "w", encoding="utf-8") as fh:
    json.dump(manifest, fh, indent=2, ensure_ascii=False); fh.write("\n")
PY
git add manifest.json && git commit -m "release: $VERSION" --quiet 2>/dev/null || true
cd "$WORKSPACE_ROOT"
python3 scripts/export-mods.py "$MOD_ID" 2>&1 | tail -2
ZIP_PATH="$WORKSPACE_ROOT/exports/gen2/${MOD_ID}.zip"
ZIP_PATH2="$WORKSPACE_ROOT/exports/gen2/$(echo $MOD_ID | tr '[:upper:]' '[:lower:]').zip"
[ -f "$ZIP_PATH2" ] && ZIP_PATH="$ZIP_PATH2"
python3 - "$ZIP_PATH" "$VERSION" "$MOD_ID" <<'PY'
import json, sys, zipfile
with zipfile.ZipFile(sys.argv[1]) as z:
    names=[n for n in z.namelist() if n.endswith('manifest.json')]
    assert names
    with z.open(names[0]) as f: v=json.load(f)["version"]
if v != sys.argv[2]: raise SystemExit(f"packed manifest says {v}, expected {sys.argv[2]}")
print(f"manifest reports {v}")
PY
(cd "$(dirname "$ZIP_PATH")" && sha256sum "$(basename "$ZIP_PATH")" > sha256sums.txt)
git -C "$MOD_DIR" tag "$TAG"
echo "Tagged $TAG. Zip: $ZIP_PATH"
