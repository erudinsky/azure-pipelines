FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick netcat
# Configuring main directory
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

ENV BUNDLER_VERSION='2.0.1'
RUN gem install bundler -v 2.0.1
RUN bundle install --jobs 20 --retry 5 --without development test

# Adding project files
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
