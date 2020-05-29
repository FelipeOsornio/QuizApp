require 'sinatra'

class Application
  attr_accessor :quiz, :manager, :user_request, :player_request, :question_request

  def initialize(quiz, manager, user_request, player_request, question_request)
    @quiz = quiz
    @manager = manager
    @user_request = user_request
    @player_request = player_request
    @question_request = question_request
  end

  get '/' do

  end

  get '/quiz' do

  end

  get '/scores' do

  end

  get '/question' do

  end

  get '/upload-csv' do

  end

  get '/get-feedback' do

  end

  post '/login' do

  end

  post '/scores' do

  end

  post '/start-quz' do

  end

  post '/upload-csv' do

  end

  post '/check-questions' do

  end

  delete '/question' do

  end
end
