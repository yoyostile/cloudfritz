FROM ruby:2.5-alpine

RUN apk update && apk add --no-cache build-base ruby-dev

WORKDIR /app
ADD app.rb /app
ADD Gemfile /app
ADD Gemfile.lock /app

ENV RACK_ENV=production

RUN gem install bundler
RUN bundle install

RUN apk del build-base ruby-dev

CMD ["ruby", "/app/app.rb"]
