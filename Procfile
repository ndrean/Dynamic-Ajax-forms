# Heroku start

web: bin/start-nginx bundle exec puma -t 5:5  --config config/puma-heroku.rb

# version for Heroku without nginx: !! change in puma.rb !!
#web: bundle exec puma -t 5:5 -p ${PORT:-3000} 

