require 'rails_helper'
require 'support/model_setup'

RSpec.describe Trabox::Relay::Relayable do
  describe RelayableTest do
    describe '#unpublished' do
      context 'published_atがnullのレコードがあるとき' do
        before { @expected = create_list(:relayable_test, 10) }

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
      let(:relayable_test) { create(:relayable_test) }

      subject { relayable_test.published_done! message_id }

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
            change(relayable_test, :message_id).and(change(relayable_test, :published_at)),
          )
        end
      end
    end
  end
end
