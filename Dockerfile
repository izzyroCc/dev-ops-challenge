FROM ruby:2.7

RUN apt-get update
RUN apt-get install -y build-essential nodejs postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

RUN bundle config set build.nokogiri --use-system-libraries

RUN bundle install --jobs=4 --retry=3

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]