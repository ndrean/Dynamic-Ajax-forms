FROM ruby:2.6.6-alpine
RUN apk update && apk add bash build-base  git curl     postgresql-dev postgresql-client postgresql-libs tzdata


ENV RAILS_ROOT /var/www/code
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT


COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler:2.1.4   && bundle install --no-binstubs

RUN apk add nodejs yarn


RUN gem install bundler --no-document && bundle install --no-binstubs || bundle check

# RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#     && apt install -y nodejs



# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update && apt-get install -y yarn


COPY . .
RUN bundle exec rake assets:precompile
RUN bundle exec rake assets:clobber

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "rails", "server", "-b", "0.0.0.0"]
