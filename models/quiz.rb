class Quiz
  attr_accessor :player, :question_answer, :user_answer

  def initialize(player, question_answer, user_answer)
    @player = player
    @question_answer = question_answer
    @user_answer = user_answer
  end

  def number_corrects
    corrects = 0

    (0..@question_answer.length()).each do |idx|
      corrects += @question_answer[idx] == @user_answer[idx] ? 1 : 0
    end

    corrects
  end

end
