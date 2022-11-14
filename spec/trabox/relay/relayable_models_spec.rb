require 'rails_helper'
require 'support/model_setup'

RSpec.describe Trabox::Relay::RelayableModels do
  describe '.list' do
    it "#{described_class.name}をincludeしているモデルの配列を返す" do
      expect(described_class.list).to match_array [RelayerTest, RelayableTest]
    end
  end
end
