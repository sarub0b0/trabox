ARG RUBY_VERSION=3.1

FROM ruby:${RUBY_VERSION}

WORKDIR /app

COPY . .

RUN bundle install


CMD ["bash"]
