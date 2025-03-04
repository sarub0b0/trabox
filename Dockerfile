ARG RUBY_VERSION

FROM ruby:${RUBY_VERSION}

WORKDIR /app

COPY . .

RUN bundle install


CMD ["bash"]
