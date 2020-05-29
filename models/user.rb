require 'json'
require_relative './print'

class User < Print
  attr_accessor :user, :pass

  def initialize(json)
    data_hash = JSON.parse(json)
    @user = data_hash["user"]
    @pass = data_hash["pass"]
  end
  
  def hide
    encrypted = ""
    @pass.each_char {|i| encrypted += "*"}
    encrypted
  end
  
  def print
    "Question { user => #{@user}, pass => #{hide} }" 
  end
  
end

