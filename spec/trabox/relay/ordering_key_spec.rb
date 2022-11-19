require 'rails_helper'

RSpec.describe Trabox::Relay::OrderingKey do
  describe '.initialize' do
    subject { described_class.new key }

    context 'Procを設定したとき' do
      let(:key) { ->(arg) { "#{arg}" } }

      it { expect { subject }.not_to raise_error }
    end

    context 'Stringを設定したとき' do
      let(:key) { 'test' }

      it { expect { subject }.not_to raise_error }
    end

    context 'Stringでない値を設定したとき' do
      it 'ArgumentErrorを返す' do
        expect { described_class.new 0 }.to raise_error(ArgumentError)
        expect { described_class.new true }.to raise_error(ArgumentError)
        expect { described_class.new Object.new }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#call' do
    subject { described_class.new key }
    context '文字列を返すProcを設定したとき' do
      let(:key) { ->(a, b) { "proc-#{a}-#{b}" } }

      it '文字列を返す' do
        expect(subject.call('A', 'B')).to eq('proc-A-B')
      end
    end

    context 'Stringを設定したとき' do
      let(:key) { 'test' }
      it '文字列を返す' do
        expect(subject.call).to eq('test')
      end

      it '引数を与えてもエラーにならない' do
        expect(subject.call(1, 2, 3)).to eq('test')
      end
    end

    context '文字列を返さないProcを設定したとき' do
      let(:key) { ->(a, b) { a + b } }

      it 'エラーを返す' do
        expect { subject.call(1, 2) }.to raise_error(RuntimeError)
      end
    end
  end
end
