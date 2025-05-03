#!/usr/bin/env bash
# exit on error
set -o errexit

echo "running: bundle exec rails db:migrate"
bundle exec rails db:migrate

echo "running: bundle exec rails db:prepare"
bundle exec rails db:prepare
