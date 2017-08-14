class Hand
  FACE_VALUES = '23456789TJQKA'.freeze
  STRAIGHT = 'straight'.freeze
  FLUSH = 'flush.freeze'
  STRAIGHT_FLUSH = 'straight flush'.freeze
  
  RANKS = [
    [1, 1, 1, 1, 1],
    [2, 1, 1, 1],
    [2, 2, 1],
    [3, 1, 1],
    STRAIGHT,
    FLUSH,
    [3, 2],
    [4, 1],
    STRAIGHT_FLUSH
  ]
  include Comparable
  attr_reader :cards
  attr_reader :score
  attr_reader :hand
  
  def initialize(cards)
    # Array of [[rank, suit], ...]
    Debug.call(cards)
    
    @cards = cards.map { |c| c.split('') }.map do |face, suit|
      [FACE_VALUES.index(face), suit]
    end.sort do |a, b|
      b[0] <=> a[0] # reverse sort
    end
    faces = @cards.map(&:first)
    @hand = faces.uniq.map { |c| faces.count(c) }.sort.reverse

    Debug.call("cards #{@cards}", "hand #{@hand}")
  end

  def <=>(other)
    test = rank <=> other.rank
    return test unless test.zero?

    rank_by_cards(other)
  end

  def rank
    RANKS.index(
      if straight? && flush?
        STRAIGHT_FLUSH
      elsif flush?
        FLUSH
      elsif straight?
        STRAIGHT
      else
        hand
      end
    )
  end

  def rank_by_cards(other)
    cards.map(&:first).zip(other.cards.map(&:first)).each do |r|
      v = r[0] <=> r[1]
      return v unless v.zero?
    end

    # draw
    0
  end

  def straight?
    hand.length == 5 && cards[0][0] - cards[4][0] == 4
  end

  def flush?
    cards.map(&:last).uniq.length == 1
  end
end
