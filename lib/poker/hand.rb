class Poker::Hand
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
    values = tmp.map { |v, _| FACE_VALUES.index(v) }

    # all same suit
    @flush = tmp.map(&:last).uniq.length == 1

    # 5 different cards in order
    @straight = values.uniq.length == 5 && values.max - values.min == 4

    # tuple of card counts. sorted by [count, face_value]
    @hand = values.uniq.map { |v| [values.count(v), v] }.sort.reverse.tap do |a|
      # matching card values
      @values = a.map(&:last)
    end.map(&:first)

    Debug.call("cards #{@values} #{@flush}, hand #{@hand}")
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
    values.uniq.zip(other.values.uniq).each do |r|
      v = r[0] <=> r[1]
      return v unless v.zero?
    end

    # draw
    0
  end

  def straight?
    @straight
  end

  def flush?
    @flush
  end

  private
  def sort(values)
  end
end
