class Quiz
  attr_accessor :player, :question_list, :number_question

  def initialize(player, question_list)
    @player = player
    @number_question = question_list.length()
  end

  def number_corrects
    -1
  end

  def best_scores
    []
  end
end
