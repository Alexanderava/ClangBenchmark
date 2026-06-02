#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="ClangBenchmark"
# GitHub PAT for leaderboard submissions (not committed to git)
GH_TOKEN="${CLANGBENCH_GH_TOKEN:-}"
BUILD_DIR="$PROJECT_DIR/.build"
APP_BUNDLE="$PROJECT_DIR/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS/MacOS"
RESOURCES_DIR="$CONTENTS/Resources"

echo "🔨 Building $APP_NAME..."
echo ""

# Step 1: Build with SwiftPM
cd "$PROJECT_DIR"
swift build -c release --arch arm64 2>&1

BINARY="$BUILD_DIR/arm64-apple-macosx/release/$APP_NAME"
if [ ! -f "$BINARY" ]; then
    echo "❌ Binary not found at $BINARY"
    exit 1
fi

echo "✅ Build complete: $(ls -lh "$BINARY" | awk '{print $5}')"

# Step 2: Create .app bundle structure
echo ""
echo "📦 Creating .app bundle..."

rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR/TestSources"
mkdir -p "$RESOURCES_DIR/l10n"

# Step 3: Copy binary
cp "$BINARY" "$MACOS_DIR/$APP_NAME"
chmod +x "$MACOS_DIR/$APP_NAME"

# Step 4: Copy resources (C++ test files + l10n)
cp "$PROJECT_DIR/Sources/ClangBenchmark/TestSources/"*.cpp "$RESOURCES_DIR/TestSources/"
cp "$PROJECT_DIR/Sources/ClangBenchmark/l10n/"*.json "$RESOURCES_DIR/l10n/"

# Step 5: Generate app icon (if not already)
ICON_PATH="/tmp/AppIcon.icns"
if [ ! -f "$ICON_PATH" ]; then
    echo "⚠️  Icon not found, generating..."
    python3 "$PROJECT_DIR/scripts/generate_icon.py"
fi
cp "$ICON_PATH" "$RESOURCES_DIR/AppIcon.icns" 2>/dev/null || echo "⚠️  No icon file"

# Step 6: Create PkgInfo
echo "APPL????" > "$CONTENTS/PkgInfo"

# Step 7: Create Info.plist
cat > "$CONTENTS/Info.plist" << 'PLISTEOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>Clang 基准测试</string>
    <key>CFBundleExecutable</key>
    <string>ClangBenchmark</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIconName</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.clangbenchmark.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Clang 基准测试</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2026. All rights reserved.</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.developer-tools</string>
</dict>
</plist>
PLISTEOF

echo ""
echo "✅ .app bundle created successfully!"
echo ""
echo "📁 $APP_BUNDLE"
echo "   ├── Contents/"
echo "   │   ├── Info.plist"
echo "   │   ├── PkgInfo"
echo "   │   ├── MacOS/$APP_NAME"
echo "   │   └── Resources/"
echo "   │       ├── AppIcon.icns"
echo "   │       └── TestSources/ ($(ls "$RESOURCES_DIR/TestSources/" | wc -l | tr -d ' ') files)"
echo ""
echo "🚀 To launch:"
echo "   open \"$APP_BUNDLE\""
echo ""

# Step 8: Launch the app
open "$APP_BUNDLE"
echo "▶️  Launching..."

# Inject GitHub token for leaderboard (not committed to source)
if [ -n "$GH_TOKEN" ]; then
    defaults write ClangBenchmark github_pat "$GH_TOKEN" 2>/dev/null || true
    echo "🔑 Leaderboard token configured"
else
    echo "⚠️  No GH_TOKEN env — leaderboard submit disabled"
fi
