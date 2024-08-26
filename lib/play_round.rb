# frozen_string_literal: true

require_relative 'guess'
require_relative 'make_code'
require_relative 'player_messages'

# class that represent one round of mastermind
class PlayRound
  def initialize
    @code = Guess.new
    @tries = 0
  end

  private

  attr_accessor :code, :tries

  public

  def begin_round
    code.make_computer_guess
    PlayerMessages.begin_round
    play_round
  end

  def play_round
    PlayerMessages.announce_round(tries)
    PlayerMessages.promt_player
    guess = Guess.new
    guess.player_guess
    result = code.rate_guess(guess.current_guess, code.current_guess)
    guess.print_guess
    guess.print_guess_result(result)
    player_won?(result[1])
  end

  def player_won?(result)
    if result == 4
      puts 'you win!'
      return
    end

    self.tries += 1
    return play_round unless tries > 12

    puts 'you lose'
  end
end
