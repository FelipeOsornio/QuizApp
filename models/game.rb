require_relative './quiz'
require_relative './player'

class Game
  attr_accessor :quiz, :player

  def initialize
    @quiz = Quiz.new
    @player = Player.new
  end

  def new_quiz
    @quiz = Quiz.new
  end
end
