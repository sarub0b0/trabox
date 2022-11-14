FROM ruby:3

WORKDIR /app

COPY . .

RUN bundle install


CMD ["bash"]
