#!/bin/sh

# Create .env.production file with VITE_API_URL
echo "Building with environment variables:"
echo "VITE_API_URL=${VITE_API_URL}"

# Create .env.production file
cat > .env.production << EOF
VITE_API_URL=${VITE_API_URL}
EOF

echo "Created .env.production file:"
cat .env.production
