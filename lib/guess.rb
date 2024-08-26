# frozen_string_literal: true

require 'colorize'

INPUT = /(red|yellow|green|blue|black|white)/.freeze
COLORSTRINGS = { 'red' => :red,
                 'yellow' => :yellow,
                 'green' => :green,
                 'blue' => :blue,
                 'black' => :black,
                 'white' => :white }.freeze

# module to enables the computer to make a random guess out of the available colors
module MakeAGuess
  def make_guess
    Array.new(4).map { |_| COLORS.sample }
  end
end

# class to represent a player's guess
class Guess
  include MakeAGuess

  def initialize
    @current_guess = %i[empty empty empty empty]
    @position = 0
  end

  private

  def lines_correct?(guess)
    guess.each do |line|
      return false unless INPUT.match(line.strip)
    end
    true
  end

  def correct_guess?(guess)
    return PlayerMessages.wrong_number_of_colors if guess.length != 4

    lines_correct?(guess)
  end

  def count_blacks(guess, code)
    black = 0
    guess.each_with_index do |color_guess, i_guess|
      code.each_with_index do |color_code, i_code|
        black += 1 if color_guess == color_code && i_guess == i_code
      end
    end
    black
  end

  def count_color(guess, code, color)
    if guess.select { |c| c == color }.length > code.select { |c| c == color }.length
      code.select { |c| c == color }.length
    else
      guess.select { |c| c == color }.length
    end
  end

  def count_whites(guess, code)
    correct_color = 0
    COLORS.each do |color|
      next unless guess.select { |c| c == color }.length.positive? && code.select { |c| c == color }.length.positive?

      correct_color += count_color(guess, code, color)
    end
    correct_color
  end

  public

  attr_accessor :current_guess, :position

  def make_computer_guess
    self.current_guess = make_guess
  end

  def fist_guess
    self.current_guess = %i[red white black blue]
  end

  def second_guess
    self.current_guess = %i[red white black yellow]
    [%i[blue yellow], 3]
  end

  def replace_color(color, found_colors, found)
    correct_guess(found)
    tries = 0
    index = position % 4
    self.position += 1
    until (current_guess[index] != color && (found[index] == :empty || found[index] == color
                                            )) || tries == 4
      index += 1
      index %= 4
      # puts "try to insert color #{color} at #{index}"
      tries += 1
    end
    # return replace_color(color, found_colors, found) if found[index] != :empty && found[index] != color

    colors = [current_guess[index], color]
    current_guess[index] = color
    [colors, index]
  end

  def correct_guess(found)
    found.each_with_index { |color, index| current_guess[index] = color unless color == :empty }
  end

  def print_colors
    COLORS.each do |color|
      print color.to_s.colorize(color)
      print ' '
    end
    puts ''
  end

  def print_guess
    current_guess.each do |color|
      print color.to_s.colorize(color)
      print ' '
    end
    puts ''
  end

  def rate_guess(guess, code)
    correct = 0
    correct += count_blacks(guess, code)
    correct_color = count_whites(guess, code) - correct
    [correct_color, correct]
  end

  def player_guess
    guess = gets.chomp.split(',')

    return player_guess unless correct_guess?(guess)

    self.current_guess = guess.map { |e| COLORSTRINGS[e.strip] }
  end

  def print_guess_result(result)
    result[0].times { print 'white '.colorize(:white) }
    puts ''
    result[1].times { print 'black '.colorize(:black) }
    puts "#{result[0]} white #{result[1]} black"
  end
end
