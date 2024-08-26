# frozen_string_literal: true

require_relative 'lib/guess'
require_relative 'lib/make_code'
require_relative 'lib/play_round'
require_relative 'lib/player_messages'
require_relative 'lib/computer_round'

COLORS = %i[red yellow green blue black white].freeze

PlayerMessages.start_game
mode = PlayerMessages.choose_mode
puts "mode = #{mode}"
round = mode == 'g' ? PlayRound.new : ComputerRound.new
round.begin_round
