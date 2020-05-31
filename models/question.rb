require 'json'
require_relative './print'

class Question < Print
  attr_accessor :question, :options, :answer

  def initialize(hash)
    @question = hash['Question']

    @options = []
    hash['Options'].each {|option| @options << option}

    @answer = hash['Answer']
  end

  def print
    "Question { question => #{@question}, options => #{@options}, answer => #{@answer} }"
  end
end