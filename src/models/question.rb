require 'json'

class Question
  attr_accessor :question, :options, :answer

  def initialize(hash)
    @question = hash['Question']

    @options = []
    hash['Options'].each {|option| @options << option}

    @answer = hash['Answer']
  end

end