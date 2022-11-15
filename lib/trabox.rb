require 'trabox/version'
require 'trabox/railtie'

require 'trabox/relay/relayable'
require 'trabox/relay/relayable_models'
require 'trabox/relay/publisher'
require 'trabox/relay/relayer'
require 'trabox/command'

module Trabox
  DEFAULT_SELECT_LIMIT = 3
end
