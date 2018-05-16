FROM ruby:2.5-alpine

RUN apk update && apk add --no-cache build-base ruby-dev

WORKDIR /app
ADD . .

ENV RACK_ENV=production

RUN gem install bundler
RUN bundle install

CMD ["ruby", "/app/app.rb"]
