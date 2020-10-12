FROM ruby:2.6.6-alpine
RUN apk update && apk add --update --no-cache --virtual build-dependency build-base bash  git curl ruby-dev postgresql-dev  


ENV RAILS_ROOT /var/www/code
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

ENV RAILS_ENV='development'

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler:2.1.4   
RUN bundle install 
#--without development test

RUN apk add postgresql-client postgresql-libs nodejs yarn tzdata

RUN apk del build-dependency


COPY . .
RUN bundle exec rake assets:precompile
RUN bundle exec rake assets:clobber

# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
ENTRYPOINT ["bundle", "exec"]
EXPOSE 3000

# Start the main process.
# CMD ["puma", "-C", "config/puma.rb"]
CMD [ "rails", "s", "-b", "0.0.0.0"] 
#bind to all
