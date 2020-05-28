require 'minitest/autorun'
require 'json'
require '../models/user'

class TestUser < Minitest::Test

  def setup
    @file = File.read('../json/user.json')
    @user = User.new(@file)
  end

  def test_question
    assert_equal \
    'Question { user => rafael_m, pass => ****** }',
    @user.print
  end
end
