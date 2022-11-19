log_level = Rails.logger.level

trap('USR1') do
  Rails.logger.level = :debug
end

trap('USR2') do
  Rails.logger.level = log_level
end
