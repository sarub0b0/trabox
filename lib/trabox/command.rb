require 'rails/command'

module Trabox
  module Command
    def self.invoke(_command, _argv = [])
      Rails::Command.invoke 'runner', ['puts Rails.env']
    end
  end
end
