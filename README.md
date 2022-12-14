# Trabox

\[[Japanese](README.ja.md)]\[[English](README.md)]

Transactional-Outbox for Rails.

## Features

- Publishing event data in transactional-outbox pattern
- Polling multiple databases and outbox tables
- Custom publisher/subscriber
- Custom Metrics with dogstatsd
- Ensure message ordering

**Supported publisher**

- Google Cloud Pub/Sub

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

**additional option: --polymorphic=\<NAME>**
This option is inserted references column in generated outbox model.
This use to associate event record with outbox record when the application is designed immutable data model.

example:`bin/rails g trabox:model example --polymorphic=event`

```ruby
class CreateExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :examples do |t|
      t.references :event, polymorphic: true, null: false # additional column
      t.binary :event_data
      t.string :message_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
```

### Running relayer

```bash
bin/trabox relay

# Help
bin/trabox relay -h
Usage: trabox relay [OPTIONS]

Overwrite configuration

    -l, --limit NUM
    -i, --interval SEC
    -L, --[no-]lock
        --log-level LEVEL


```

### Running subscriber

```bash
bin/trabox subscribe

# Help
bin/trabox subscribe -h
Usage: trabox subscribe [OPTIONS]

Overwrite configuration

        --log-level LEVEL
```

## Metrics

| name                            | description                                  |
| ------------------------------- | -------------------------------------------- |
| unpublished_event_count         | Number of events that will be published      |
| published_event_count           | Number of published events                   |
| find_events_error_count         | Number of errors that find events to publish |
| publish_event_error_count       | Number of publication errors                 |
| update_event_record_error_count | Number of record update errors               |

## Contributing

Bug reports and pull requests are welcome.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
