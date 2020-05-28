require 'minitest/autorun'
require 'json'
require '../models/player'

class TestPlayer < Minitest::Test

  def setup
    @file = File.read('../json/player.json')
    @player = Player.new(@file)
  end

  def test_question
    assert_equal \
    'Player { username => skdv, score => 95 }',
    @player.print
  end
end