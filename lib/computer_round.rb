# frozen_string_literal: true

require_relative 'guess'
require_relative 'make_code'
require_relative 'player_messages'
require 'pry-byebug'

# class to let the computer guess the code
class ComputerRound
  def initialize
    @code = Guess.new
    @guess = Guess.new
    @tries = 0
    @result = [0, 0]
    @waiting_colors = []
    @guesses = []
    @found_colors = []
    @found = %i[empty empty empty empty]
    @possible_colors = COLORS
  end

  attr_accessor :code, :tries, :guess, :result, :waiting_colors, :guesses, :found_colors, :found, :possible_colors

  def begin_round
    PlayerMessages.begin_computer_round
    code.player_guess
    code.print_guess
    play
  end

  def play
    while tries < 12
      turn
      puts result
      if result[1] == 4
        puts 'computer wins'
        return
      end
      self.tries += 1
    end
    puts 'computer loses'
  end

  def make_guess
    colors = []
    guess.fist_guess if tries.zero?
    colors = guess.second_guess if tries == 1
    waiting_colors << found_colors[0] if waiting_colors.empty? && !found_colors.empty?
    waiting_colors << possible_colors.sample if waiting_colors.empty?
    colors = guess.replace_color(waiting_colors.pop, found_colors, found) if tries > 1
    colors
  end

  def turn
    curr_guess = make_guess
    colors = curr_guess[0]
    index = curr_guess[1]
    # puts "colors #{colors}, tries #{tries}"
    guess.current_guess = found unless found.include?(:empty)
    self.result = guess.rate_guess(code.current_guess, guess.current_guess)
    guesses << [guess.current_guess, result]
    # p guesses
    # puts guesses[tries]
    # puts guesses[tries - 1] if tries > 0
    move_to_waiting_colors(colors, guesses[tries - 1][1], guesses[tries][1]) if tries.positive?
    move_to_found_colors(colors, guesses[tries - 1][1], guesses[tries][1]) if tries.positive?
    found?(colors, guesses[tries - 1][1], guesses[tries][1], index)
    # puts "found colors #{found_colors}"
    # puts found
    p possible_colors
    guess.print_guess
    p found_colors
  end

  def move_to_waiting_colors(colors, result_old, result_new)
    puts "result_old.sum #{result_old.sum}, result_new.sum #{result_new.sum}"
    return if result_old.sum == result_new.sum

    waiting_colors << if result_old.sum < result_new.sum
                        colors[1]
                      else
                        colors[0]
                      end
  end

  def move_to_found_colors(colors, result_old, result_new)
    return if result_old.sum == result_new.sum

    # binding.pry
    if result_old.sum < result_new.sum
      found_colors << colors[1] unless found_colors.include?(colors[1])
      self.possible_colors = possible_colors - [colors[0]]
    else
      found_colors << colors[0] unless found_colors.include?(colors[0])
      self.possible_colors = possible_colors - [colors[1]]
    end
  end

  def found?(colors, result_old, result_new, index)
    return if result_old[1] == result_new[1]

    if result_old[1] < result_new[1]
      found[index] = colors[1]
      guess.current_guess[index] = colors[1]
      self.found_colors = found_colors - [colors[1]]
    else
      found[index] = colors[0]
      guess.current_guess[index] = colors[0]
      self.found_colors = found_colors - [colors[0]]
    end
  end
end
