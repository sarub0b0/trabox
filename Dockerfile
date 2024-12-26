ARG RUBY_VERSION=3.4

FROM ruby:${RUBY_VERSION}

WORKDIR /app

COPY . .

RUN bundle install


CMD ["bash"]
