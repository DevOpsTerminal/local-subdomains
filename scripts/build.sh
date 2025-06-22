#!/bin/bash
set -e

echo "🔨 Starting build process..."

# Build services
echo "🚀 Building Docker services..."
make build

# Run tests
echo "🧪 Running tests..."
make test

echo "✅ Build completed successfully!"
