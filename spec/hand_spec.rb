HANDS = {
  high_card: %w[AD 2H 3C 4S 5D],
  pair: %w[4H 6H 4D 2H 5H],
  two_pair: %w[4H 6H 4H 6H 5C],
  three_of_a_kind: %w[5H 5D 5S 4D 2H],
  straight: %w[JH TC QD AS KD],
  flush: %w[4H 5H 6H JH QH],
  full_boat: %w[4H 6H 4H 6H 6C],
  for_of_a_kind: %w[4H 4H 4H 4H 5C],
  straight_flush: %w[4H 6H 3H 2H 5H],
  royal_flush: %w[JS TS QS AS KS],
}.freeze

SCORES = {
  two_pair: [[2, 2, 1], [4, 2, 3]],
  full_boat: [[3, 2], [4, 2]],
  for_of_a_kind: [[4, 1], [2, 3]],
  high_card: [[1, 1, 1, 1, 1], [12, 3, 2, 1, 0]],
  straight_flush: [[1, 1, 1, 1, 1], [4, 3, 2, 1, 0]],
}.freeze

# rubocop:disable Metrics/BlockLength
RSpec.describe Poker::Hand do
  context '#initialize' do
    subject { Poker::Hand.new(HANDS[:straight_flush]) }
    let(:values) { subject.values }

    it 'initializes the cards' do
      aggregate_failures do
        expect(values).to be_an Array
        expect(values.length).to eq(5)
      end
    end
    it 'should have sorted integer values' do
      expect(values).to eq([4, 3, 2, 1, 0])
    end
  end

  context '#straight?' do
    it 'should be true' do
      expect(Poker::Hand.new(HANDS[:straight]).straight?).to be true
    end

    it 'should be false' do
      expect(Poker::Hand.new(HANDS[:pair]).straight?).to be false
    end
  end

  context '#flush?' do
    it 'should be true' do
      expect(Poker::Hand.new(HANDS[:straight_flush]).flush?).to be true
    end

    it 'should be false' do
      expect(Poker::Hand.new(HANDS[:straight]).flush?).to be false
    end
  end

  context '#hand' do
    SCORES.each do |k, (h, v)|
      it "should parse a #{k}" do
        hand = Poker::Hand.new(HANDS[k])
        expect(hand.hand).to eq(h)
        expect(hand.values).to eq(v)
      end
    end
  end

  context '#rank_by_card' do
    it 'should be -1' do
      expect(
        Poker::Hand.new(HANDS[:high_card]).rank_by_cards(Poker::Hand.new(HANDS[:straight]))
      ).to eq(-1)
    end

    it 'should be 1' do
      expect(
        Poker::Hand.new(HANDS[:straight]).rank_by_cards(Poker::Hand.new(HANDS[:high_card]))
      ).to eq(1)
    end

    it 'should be 0' do
      expect(
        Poker::Hand.new(HANDS[:high_card]).rank_by_cards(Poker::Hand.new(HANDS[:high_card]))
      ).to eq(0)
    end
  end

  context '#<=>' do
    (0..HANDS.length - 2).each do |i|
      winner = HANDS.keys[i + 1]
      looser = HANDS.keys[i]
      it "a #{winner} should beat a #{looser}" do
        h1 = Poker::Hand.new(HANDS[winner])
        h2 = Poker::Hand.new(HANDS[looser])
        aggregate_failures do
          expect(h1 <=> h2).to eq(1)
          expect(h1 > h2).to be true
          expect(h1 < h2).to be false
          expect(h1 == h2).to be false
        end
      end
    end

    it 'should return a draw' do
      h1 = Poker::Hand.new(HANDS[:pair])
      h2 = Poker::Hand.new(HANDS[:pair])
      aggregate_failures do
        expect(h1 <=> h2).to eq(0)
        expect(h1 == h2).to be true
      end
    end
  end
end
