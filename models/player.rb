require 'json'
require_relative './print'

class Player < Print
  attr_accessor :username, :score

  def initialize
    @username = ''
    @score = -1
  end
  
  def print
    "Player { username => #{@user}, score => #{@score} }" 
  end

end
