# Trabox

\[[Japanese](README.ja.md)]\[[English](README.md)]

Transactional-Outbox for Rails.

**Supported publisher**

- Google Cloud Pub/Sub

## Features

- Publishing event data in transactional-outbox pattern
- Polling multiple databases and outbox tables
- Custom publisher/subscriber
- Custom Metrics with dogstatsd
- Ensure message ordering

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trabox'
```

And then execute:

```bash
bundle install
bin/rails g trabox:configure
```

This will generate config file `config/initializers/trabox.rb`.

**Optional**:

```bash
bundle binstubs trabox
```

## Usage

### Generate outbox tables

```bash
# generate model
bin/rails g trabox:model <NAME>

# Help
bin/rails g trabox:model --help
Usage:
  rails generate trabox:model NAME [field[:type][:index] field[:type][:index]] [options]
...
```

### Running relayer

```bash
bin/trabox relay

# help
bin/trabox relay -h
```

### Running subscriber

```bash
bin/trabox subscribe

# help
bin/trabox subscribe -h
```

<!-- ## Architecture -->
<!---->
<!-- ![Architecture](docs/images/architecture.jpg) -->
<!---->
<!-- ### Sequence diagram -->
<!---->
<!-- ![Sequence diagram](docs/images/sequence-diagram.svg) -->
<!---->

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
