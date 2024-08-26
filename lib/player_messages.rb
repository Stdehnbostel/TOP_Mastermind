# frozen_string_literal: true

# class that holds a collection of messages for the player.
class PlayerMessages
  def self.begin_round
    puts 'Try to guess the secret code. you can try 12 times'
    puts 'for every correct color, you get one white anf for every correct color plus position you get one black.'
  end

  def self.promt_player
    puts 'make a guess, you have to type a combination of possible colors'
    puts 'you need to choose 4 colors'
    puts 'the possible colors are: red, yellow, green, blue and black'
  end

  def self.wrong_number_of_colors
    puts 'you need to choose 4 colors'
    false
  end

  def self.announce_round(round)
    puts "round #{round}"
  end

  def self.begin_computer_round
    puts 'make a secret code, the computer has to guess'
  end

  def self.start_game
    puts 'choose if you want to guess a code made by the computer'
    puts 'or if you want to mae a code for the computer to guess.'
  end

  def self.choose_mode
    puts 'enter g to guess a code and c to create a code'
    input = gets.chomp until %w[g c].include?(input)
    input
  end
end
