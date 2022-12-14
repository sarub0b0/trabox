require 'rails_helper'
require 'generators/trabox/model/model_generator'

RSpec.describe Trabox::ModelGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __dir__)

  before do
    prepare_destination
  end

  describe 'generated files' do
    describe 'model' do
      subject { file('app/models/event.rb') }

      context '--polymorphicが設定されているとき' do
        before do
          run_generator ['event', '--polymorphic=event']
        end

        it { is_expected.to exist }

        it { is_expected.to contain(/include Trabox::Relay::Relayable/) }
        it { is_expected.to contain(/belongs_to :event, polymorphic: true/) }
      end

      context '--polymorphicが未設定のとき' do
        before do
          run_generator ['event']
        end

        it { is_expected.to exist }

        it { is_expected.to contain(/include Trabox::Relay::Relayable/) }
        it { is_expected.not_to contain(/belongs_to :event, polymorphic: true/) }
      end
    end

    describe 'migrate' do
      subject { migration_file('db/migrate/create_events.rb') }

      context '--polymorphicが設定されているとき' do
        before do
          run_generator ['event', '--polymorphic=event']
        end

        it { is_expected.to exist }

        it { is_expected.to contain(/t.references :event, polymorphic: true, null: false/) }
        it { is_expected.to contain(/t.binary :event_data/) }
        it { is_expected.to contain(/t.string :message_id/) }
        it { is_expected.to contain(/t.datetime :published_at/) }
      end

      context '--polymorphicが未設定のとき' do
        before do
          run_generator ['event']
        end

        it { is_expected.to exist }

        it { is_expected.not_to contain(/t.references :event, polymorphic: true, null: false/) }
        it { is_expected.to contain(/t.binary :event_data/) }
        it { is_expected.to contain(/t.string :message_id/) }
        it { is_expected.to contain(/t.datetime :published_at/) }
      end
    end

    describe 'spec' do
      before do
        run_generator ['event', '--polymorphic=event']
      end

      subject { file('spec/models/event_spec.rb') }

      it { is_expected.to exist }
    end
  end
end
