class Poker
  DEFAULT_FILE = 'p054_poker.txt'.freeze

  require_relative 'poker/hand'
  require_relative 'debug'

  def initialize(file=nil)
    @file = file || DEFAULT_FILE
  end

  def play
    # sum [total, won]
    File.readlines(@file).reduce([0, 0]) do |(total, won), line|
      [total + 1, round(line) ? won + 1 : won]
    end
  end

  def round(line)
    cards = line.split

    Poker::Hand.new(hand(cards, 0)) > Poker::Hand.new(hand(cards, 1))
  end

  private
  # n [0, 1]
  def hand(cards, n)
    offset = n * 5
    cards[offset..offset + 4]
  end
end
