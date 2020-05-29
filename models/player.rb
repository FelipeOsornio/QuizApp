require 'json'
require_relative './print'

class Player < Print
  attr_accessor :user, :score

  def initialize(json)
    data_hash = JSON.parse(json)
    @user = data_hash["username"]
    @score = data_hash["score"]
  end
  
  
  def print
    "Player { username => #{@user}, score => #{@score} }" 
  end

end
