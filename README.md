# Trabox

[日本語](README.ja.md)

Transactional-Outbox for Rails.

**Supported publisher**

- Google Cloud Pub/Sub

## Usage

### Create outbox tables

```bash
bin/rails g trabox:model <NAME>
```

### Run

```bash
bin/trabox relay
```

```bash
bin/trabox subscribe
```

How to use my plugin.

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

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
