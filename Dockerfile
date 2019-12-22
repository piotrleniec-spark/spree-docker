FROM ruby:2.6.3

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  apt-get install -y nodejs && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install yarn

RUN adduser --disabled-password --gecos '' spree
WORKDIR /home/spree/app
RUN chown spree:spree .

USER spree

COPY --chown=spree:spree spark-starter-kit/Gemfile .
COPY --chown=spree:spree spark-starter-kit/Gemfile.lock .
RUN bundle install --without development test

COPY --chown=spree:spree spark-starter-kit .

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES 1
ENV RAILS_LOG_TO_STDOUT 1

RUN DATABASE_ADAPTER=nulldb SECRET_KEY_BASE=abc123 rails assets:precompile
