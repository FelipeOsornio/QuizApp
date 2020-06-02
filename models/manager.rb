class Manager
  attr_accessor :question_list, :user

  def initialize(question_list, user)
    @question_list = question_list
    @user = user
  end
end
