# Trabox

\[[Japanese](README.ja.md)]\[[English](README.md)]

Transactional-Outbox for Rails.

![](./docs/images/architecture.jpg)

## 機能

- Transactional-Outbox パターンでのイベントデータ公開
- 複数のデータベース・Outbox テーブルに対応
- `publish/subscribe`メソッドをもつ自作の publisher/subscriber を使用可能
- dogstatsd ベースのメトリクス
- 受信するメッセージの順序を維持する

**サポートしている publisher**

- Google Cloud Pub/Sub

## インストール

`Gemfile`に下記を追記

```ruby
gem 'trabox'
```

下記コマンドを実行

```bash
bundle install
bin/rails g trabox:configure
```

これで、`config/initializers/trabox.rb`ファイルが生成されます。

**オプション**

```bash
bundle binstubs trabox
```

## 使い方

### outbox テーブルの作成

下記コマンドで outbox モデルのファイルが作成されます。  
`bin/rails g model`のオプションを使えるので、必要に応じて変更してください。

```bash
# generate model
bin/rails g trabox:model <NAME>

# Help
$ bin/rails g trabox:model --help
Usage:
  rails generate trabox:model NAME [field[:type][:index] field[:type][:index]] [options]
...
```

**追加のオプション: --polymorphic=\<NAME>** オプションをつけると`references`カラムが追加されます。  
このオプションはイミュータブルデータモデルに基づいた設計のときにイベントデータと outbox データを関連づけるのに使用します。

例：`bin/rails g trabox:model event --polymorphic=event`

```ruby
class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :event, polymorphic: true, null: false # --polymorphicオプションで生成されたカラム
      t.binary :event_data
      t.string :message_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
```

### Event データの登録

Publish するイベントデータを作成した outbox テーブルに登録します。

```ruby
# Your rails application
ActiveRecord::Base.transaction do
  user = User.create! name: 'hoge'

  Event.create! event_data: <serialized_user_event>
end
```

### Relayer 実行

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

#### Subscriber 実行

```bash
bin/trabox subscribe

# Help
 bin/trabox subscribe -h
Usage: trabox subscribe [OPTIONS]

Overwrite configuration

        --log-level LEVEL
```

## メトリクス

メトリクスの名前空間の初期値は`trabox`です。  
名前空間は`TRABOX_METRIC_NAMESPACE`環境変数で変更可能です。

| 名前                            | 説明                                             |
| ------------------------------- | ------------------------------------------------ |
| unpublished_event_count         | パブリッシュするイベント数                       |
| published_event_count           | パブリッシュしたイベント数                       |
| find_events_error_count         | パブリッシュするイベントの取得に失敗した数       |
| publish_event_error_count       | イベントのパブリッシュに失敗した数               |
| update_event_record_error_count | パブリッシュしたイベントのカラム更新に失敗した数 |

### Health check

| command   | metric name             |
| --------- | ----------------------- |
| relay     | relay.service.check     |
| subscribe | subscribe.service.check |

## Sequence diagram

![](./docs/images/sequence-diagram.svg)

## Contributing

Bug reports and pull requests are welcome.

## Development

### Install gems

```bash
bundle install
```

### Start mysql / pubsub emulator

```bash
docker-compose up
```

**db migrate**

```bash
cd spec/rails_app
bin/rails db:migrate
```

**create topic / subscribe**

```bash
rake trabox:pubsub_setup
```

### Test

```bash
bin/rspec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
