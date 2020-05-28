require 'json'
require_relative './print'

class Question < Print
  attr_accessor :question, :options, :answer

  def initialize(json)
    data_hash = JSON.parse(json)

    @question = data_hash['question']
    @options = data_hash['options'].split(',').collect(&:strip)
    @answer = data_hash['answer']
  end

  def print
    "Question { question => #{@question}, options => #{@options}, answer => #{@answer} }"
  end
end