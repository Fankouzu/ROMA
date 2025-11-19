#!/bin/bash
# Railway startup script for ROMA-DSPy
# This script ensures the application uses Railway's PORT environment variable

set -e

# Get port from Railway's PORT env var, default to 8000 if not set
PORT=${PORT:-8000}

# Start the API server with the correct port
exec roma-dspy server start --host 0.0.0.0 --port "$PORT" --workers 4

