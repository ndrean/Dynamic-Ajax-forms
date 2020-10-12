# same Dockerfile as 'Docker/app/Dockerfile', changed the WORKDIR, for standalone without nginx
FROM ruby:2.6.6-alpine
RUN apk update && apk add bash build-base  git curl     postgresql-dev postgresql-client postgresql-libs tzdata


ENV RAILS_ROOT /code
RUN mkdir -p $RAILS_ROOT

# RUN mkdir /myapp
WORKDIR $RAILS_ROOT

ENV RAILS_ENV='development'
ENV RACK_ENV='development'

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler:2.1.4   && bundle install --no-binstubs

#node.js
RUN apk add nodejs yarn


#yarn
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apk update && apk add yarn

COPY . .

RUN bundle exec rake assets:precompile
RUN bundle exec rake assets:clobber

# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
# CMD ["bundle", "exec", "puma", "--config", "config/puma-no-nginx.rb"]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
