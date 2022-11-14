require 'rails_helper'
require 'support/model_setup'

RSpec.describe Trabox::Relay::Relayable do
  FactoryBot.define do
    factory :relayed_model do
      published_at { nil }
      message_id { nil }
    end
  end

  class RelayedModel < ApplicationRecord
    include Trabox::Relay::Relayable
  end

  append_after(:all) do
    Object.instance_eval { remove_const(:RelayedModel) }
  end

  describe RelayedModel do
    create_spec_table described_class.table_name do |t|
      t.string :message_id
      t.datetime :published_at
    end

    describe '#unpublished' do
      context 'published_atがnullのレコードがあるとき' do
        before { @expected = create_list(:relayed_model, 10) }

        subject { described_class.unpublished limit: limit }

        context 'マッチしたレコードがlimitより多いとき' do
          let(:limit) { 5 }

          it 'limit数のイベント情報の配列を返す' do
            expect(subject).to eq(@expected.slice(0, limit))
          end
        end

        context 'マッチしたレコードがlimitより少ないとき' do
          let(:limit) { 30 }

          it '全てのイベント情報の配列を返す' do
            expect(subject).to eq(@expected)
          end
        end
      end

      context 'published_atがnullのレコードがないとき' do
        subject { described_class.unpublished limit: 10 }

        it '空の配列を返す' do
          expect(subject).to be_empty
        end
      end
    end

    describe '#published_done!' do
      let(:relayed_model) { create(:relayed_model) }

      subject { relayed_model.published_done! message_id }

      context 'message_idがnilのとき' do
        let(:message_id) { nil }
        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context 'message_idが\'\'のとき' do
        let(:message_id) { '' }
        it { expect { subject }.to raise_error(ArgumentError) }
      end

      context 'message_idが一文字以上の文字列のとき' do
        let(:message_id) { '1' }
        it 'message_idとpublished_atを更新する' do
          expect { subject }.to(
            change(relayed_model, :message_id).and(change(relayed_model, :published_at)),
          )
        end
      end
    end
  end
end
