# Trabox

Transactional-Outbox for Rails.



書かないといけないこと

- リポジトリでサポートしているのはGoogle Cloud Pub/Sub
- 自作のPublisher/Subscriberを使用できる
  - Publisherはイベントモデルを引数にとるpublishメソッドをもつインスタンスであること
  - Subscriberはメッセージをサブスクライブするsubscribeメソッドをもつインスタンスであること
- PublisherとSubscriberの設定値
- インストール手順
- 実行方法
- イベントモデルの解説。各フィールドについてなど
- メトリクス
- イベントモデルは複数可

**サポートしているpublisher**

- Google Cloud Pub/Sub

`Publisher/Subscriber`モジュールをincludeした自作のpublisher/subscriberを使用することもできます。

## 使い方

- configuration
- create outbox
- running

### outboxテーブルの作成

コマンドを実行するoutbox用のモデルに関するファイルが作成されます。  
`bin/rails g model`のオプションを使えるので、必要に応じて変更してください。

```bash
bin/rails g trabox:model <NAME> 
```

**追加のオプション：**`--polymorphic=<NAME>`オプションをつけると`references`カラムが追加されます。


例：`bin/rails g trabox:model example --polymorphic=event`

```ruby
class CreateExamples < ActiveRecord::Migration[6.1]
  def change
    create_table :examples do |t|
      t.references :event, polymorphic: true, null: false # --polymorphicオプションで生成されたカラム
      t.binary :event_data
      t.string :message_id
      t.datetime :published_at

      t.timestamps
    end
  end
end
```

### 実行

```bash
$ bin/trabox -h
Usage: trabox <COMMAND> [OPTIONS]
    -h, --help           Print help information
    -v, --version        Print version information

Commands:
    r, relay            Relay events
    s, subscribe        Subscribe events
```

#### Relay

```bash
$ bin/trabox relay -h
Usage: trabox relay [OPTIONS]

Overwrite configuration

    -l, --limit NUM
    -i, --interval SEC
    -L, --[no-]lock

```

#### Subscribe

```bash
bin/trabox subscribe
```

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

設定ファイルが`config/initializers/trabox.rb`に生成されるので、必要に応じて修正してください。

**オプション**

```bash
bundle binstubs trabox
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
