require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    # this is simply making an array, but ensuring that there are vowels, so it is making an array of 5, with random vowels
    @letters = Array.new(5) { VOWELS.sample }
    # this line adds 5 constants to the available letters
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # this line is randomizing the order in which it is displayed
    @letters.shuffle!
  end

  def score

    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end

