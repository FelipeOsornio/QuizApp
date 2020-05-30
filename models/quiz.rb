class Quiz
  attr_accessor :player, :question_answer, :user_answer

  def initialize
    @player = nil
    @question_answer = []
    @user_answer = []
  end

  def number_corrects
    corrects = 0

    (0..@question_answer.length() - 1).each do |idx|
      corrects += @question_answer[idx] == @user_answer[idx] ? 1 : 0
    end

    corrects
  end

end
