require 'rails_helper'
require 'generators/trabox/init/init_generator'

RSpec.describe Trabox::InitGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __dir__)

  before do
    prepare_destination
  end

  describe 'generated files' do
    subject { file('config/initializers/trabox.rb') }

    before do
      run_generator
    end

    it { is_expected.to exist }
  end
end
