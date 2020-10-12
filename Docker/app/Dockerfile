FROM ruby:2.6.6-alpine
RUN apk update && apk add bash build-base git curl postgresql-dev  


ENV RAILS_ROOT /var/www/code
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT


COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler:2.1.4   && bundle install --no-binstubs \
    gem install bundler --no-document && bundle install --no-binstubs || bundle check

RUN apk add postgresql-client postgresql-libs nodejs yarn tzdata

RUN apk del build-dependency


COPY . .
RUN bundle exec rake assets:precompile
RUN bundle exec rake assets:clobber

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
#, "rails", "server", "-b", "0.0.0.0"]
