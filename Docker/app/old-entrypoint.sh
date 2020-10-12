#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid

bundle exec rails server -p 3000 -b '0.0.0.0'
# bundle exec puma -p 3000  -C config/puma.rb

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
