class Hand
  FACE_VALUES = '23456789TJQKA'.freeze
  STRAIGHT = 'straight'.freeze
  FLUSH = 'flush'.freeze
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
  ].freeze

  include Comparable
  attr_reader :values
  attr_reader :hand

  def initialize(cards)
    Debug.call(cards)

    # Array of [[rank, suit], ...]
    tmp = cards.map { |c| c.split('') }

    @values = tmp.map { |v, _| FACE_VALUES.index(v) }.sort.reverse
    @flush = tmp.map(&:last).uniq.length == 1
    @hand = values.uniq.map { |c| values.count(c) }.sort.reverse

    Debug.call("cards #{@values} #{@flush}", "hand #{@hand}")
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
    values.zip(other.values).each do |r|
      v = r[0] <=> r[1]
      return v unless v.zero?
    end

    # draw
    0
  end

  def straight?
    hand.length == 5 && values[0] - values[4] == 4
  end

  def flush?
    @flush
  end
end
