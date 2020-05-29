class LambdaQuestion
  def self.get_all_questions
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def self.upload_questions
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def self.delete_questions
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
