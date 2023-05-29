require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    # @hidden_tag = hidden_field_tag("current_grid", value = @letters, options = {})
  end

  def score
    @input = params[:input]
    @grid = params[:grid]
    puts "calling score method"
    @message = run_game(@input, @grid)
  end

  def post
    puts "calling the post method"
  end

  def word_validation(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    response = URI.open(url).read
    hash_response = JSON.parse(response)
    hash_response["found"]
  end

  def character_include(attempt, grid)
    attempt = attempt.upcase.chars
    attempt.all? do |letter|
      grid.count(letter) >= attempt.count(letter)
    end
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys) score: score
    result = {}
    if character_include(attempt, grid) == false
      result[:message] = "Sorry but #{attempt} can't be built out of #{grid}"
    elsif word_validation(attempt) == false
      result[:message] = "sorry but #{attempt} does not appear to be an English word"
    else
      result[:message] = "Congratulations, #{attempt} is a valid English word"
    end
    result[:message]
  end

end
