# This template builds two images, to optimise caching:
# builder: builds gems and node modules
# production: runs the actual app

# Build builder image
# WHEN WE UPDATE THIS WE HAVE TO KEEP PUPPETEER IN SYNC WITH THE VERSION OF CHROMIUM THAT GETS INSTALLED
# Get the version `apk list chromium` in the running image and then update package.json https://pptr.dev/chromium-support#
# This is used for rendering PDFs
FROM ruby:3.4.4-alpine3.20 AS builder

WORKDIR /app

# Add the timezone (builder image) as it's not configured by default in Alpine
RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

# build-base: dependencies for bundle
# yarn: node package manager
# postgresql-dev: postgres driver and libraries
# git: dependencies for bundle
RUN apk add --no-cache build-base yarn postgresql15-dev git yaml-dev

# Create non-root user and group with specific UIDs/GIDs (to match production stage)
RUN addgroup -S appgroup -g 20001 && adduser -S appuser -G appgroup -u 10001

# Install gems defined in Gemfile
COPY .ruby-version Gemfile Gemfile.lock ./

# Install gems and remove gem cache
RUN bundler -v && \
    bundle config set no-cache 'true' && \
    bundle config set no-binstubs 'true' && \
    bundle config set without 'development test' && \
    bundle install --retry=5 --jobs=4 && \
    rm -rf /usr/local/bundle/cache

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_DOWNLOAD=true

# Install node packages defined in package.json
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --check-files

# Copy all files to /app (except what is defined in .dockerignore)
COPY . .

# Precompile assets
RUN RAILS_ENV=production \
    SECRET_KEY_BASE=required-to-run-but-not-used \
    GOVUK_NOTIFY_API_KEY=required-to-run-but-not-used \
    HOSTING_DOMAIN=https://required-but-not-used \
    bundle exec rails assets:precompile

# Cleanup to save space in the production image
RUN rm -rf log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache && \
    rm -rf .env && \
    find /usr/local/bundle/gems -name "*.c" -delete && \
    find /usr/local/bundle/gems -name "*.h" -delete && \
    find /usr/local/bundle/gems -name "*.o" -delete && \
    find /usr/local/bundle/gems -name "*.html" -delete

# Build runtime image
FROM ruby:3.4.4-alpine3.20 AS production

ENV GOVUK_NOTIFY_API_KEY=TestKey \
    HOSTING_DOMAIN=https://required-but-not-used

# The application runs from /app
WORKDIR /app

# Set Rails environment to production
ENV RAILS_ENV=production

# Add the timezone (prod image) as it's not configured by default in Alpine
RUN apk add --update --no-cache tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

# libpq: required to run postgres
RUN apk add --no-cache \
    libpq \
    nodejs \
    chromium \
    nodejs \
    yarn \
    udev \
    dumb-init \
    curl \
    chromium=131.0.6778.108-r0

# Create non-root user and group with specific UIDs/GIDs
RUN addgroup -S appgroup -g 20001 && adduser -S appuser -G appgroup -u 10001

# Copy files generated in the builder image
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Change ownership only for directories that need write access
RUN mkdir -p /app/tmp /app/log && chown -R appuser:appgroup /app/tmp /app/log /app/public/

# Switch to non-root user
USER 10001

# Add the commit sha to the env
ARG COMMIT_SHA
ENV GIT_SHA=$COMMIT_SHA
ENV SHA=$GIT_SHA

CMD bundle exec rails db:migrate:ignore_concurrent_migration_exceptions && \
    bundle exec rails server -b 0.0.0.0
