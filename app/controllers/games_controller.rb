require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = generate_grid(10)
  end

  def score
    @result = ''
    word = params[:word]
    if letters_found_in_grid?(word, params[:grid])
      @result = english_word?(word) ? 'valid word' : 'not english'
    else
      @result = 'not found'
    end
  end

  private

  def generate_grid(grid_size)
    alphabet = ('A'..'Z').to_a
    result = []
    (1..grid_size).each { |_i| result << alphabet.sample }
    result
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    read_url = open(url).read
    json_result = JSON.parse(read_url)
    json_result['found']
  end

  def letters_found_in_grid?(attempt, grid)
    attempt_array = attempt.upcase.split('')
    grid_array = grid.split('')

    attempt_array.all? do |letter|
      attempt_array.count(letter) <= grid_array.count(letter)
    end
  end
end
