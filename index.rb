require 'sinatra/base'
require './models/game'
require './quiz_app'
require './manager_app'

class Main < Sinatra::Base

  # Quiz routes
  get '/' do
    init
  end

  get '/start-quiz' do
    start_quiz
  end

  post '/scores' do
    scores
  end

  post '/quiz' do
    quiz
  end

  post '/get-feedback' do
    get_feedback
  end

  # Manager routes
  get '/login' do
    login
  end

  get '/upload-csv' do
    view_upload_csv
  end

  post '/question' do
    question
  end

  post '/upload-csv' do
    upload_csv
  end

  get '/delete-questions' do
    delete_questions
  end
end

Main.run!



