require 'minitest/autorun'
require 'json'
require '../models/question'

class TestQuestion < Minitest::Test

  def setup
    @file = File.read('../json/questions.json')
    @question = Question.new(@file)
  end

  def test_question
    assert_equal \
    'Question { question => question?, options => ["a", "b", "c", "d"], answer => 0 }',
    @question.print
  end
end