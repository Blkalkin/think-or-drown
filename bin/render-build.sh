#!/usr/bin/env bash

# exit on error
set -o errexit

npm run build
bundle install
rails db:migrate
rails db:seed:replant DISABLE_DATABASE_ENVIRONMENT_CHECK=1

