require 'json'

class User
  attr_accessor :user, :pass

  def initialize(user_name, password)
    @user = user_name
    @pass = password
  end

  def hide
    encrypted = ""
    @pass.each_char {|i| encrypted += "*"}
    encrypted
  end

end

