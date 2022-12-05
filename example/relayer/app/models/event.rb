class Event < ApplicationRecord
  include Trabox::Relay::Relayable
end
