require 'rails_helper'
require 'support/model_setup'

RSpec.describe Trabox::Relay::RelayableModels do
  class Model0 < ApplicationRecord
    include Trabox::Relay::Relayable
  end

  class Model1 < ApplicationRecord
    include Trabox::Relay::Relayable
  end

  create_spec_table Model0.table_name do |t|
    t.string :name
  end

  create_spec_table Model1.table_name do |t|
    t.string :name
  end

  append_after(:all) do
    Object.instance_eval { remove_const(:Model0) }
    Object.instance_eval { remove_const(:Model1) }
  end

  describe '.list' do
    it "#{described_class.name}をincludeしているモデルの配列を返す" do
      expect(described_class.list).to include(Model0, Model1)
    end
  end
end
