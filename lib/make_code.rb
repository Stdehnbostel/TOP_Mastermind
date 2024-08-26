# frozen_string_literal: true

# class to represent a players code
class MakeCode
  def initialize
    @code = %i[empty empty empty empty]
  end

  attr_accessor :code

  def print_code
    puts "#{code[0]} #{code[1]} #{code[2]} #{code[3]}"
  end

  def make_a_code
    (0..4).each do |i|
      code[i] = COLORS.sample
    end
  end
end
