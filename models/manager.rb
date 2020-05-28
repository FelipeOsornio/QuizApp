class Manager
  attr_accessor :question_list, :empty, :user

  def initialize(question_list, user)
    @question_list = question_list
    @empty = question_list == 0
    @user = user
  end
end
