require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def reset_score
    session[:score] = 0
  end

  def score
    @word = params['word']
    @letters = params['letters'].split

    session[:score] = 0 unless session[:score]
    @result = if included?
                if check_api?
                  session[:score] += @word.size
                  "Congratulations, #{@word} is a valid English word! Your score is #{session[:score]}"
                else
                  "Sorry but #{@word} does not seem to be an English word"
                end
              else
                "Sorry but #{@word} cannot be built out of the letter set: #{@letters.join}"
              end
  end

  def check_api?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = URI.open(url).read
    JSON.parse(response)['found']
  end

  def included?
    word_split = @word.upcase.split('')
    word_split.all? { |letter| @letters.count(letter) >= word_split.count(letter) }
  end
end
