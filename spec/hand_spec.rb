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
  two_pair: [2, 2, 1],
  full_boat: [3, 2],
  for_of_a_kind: [4, 1],
  high_card: [1, 1, 1, 1, 1],
  straight_flush: [1, 1, 1, 1, 1],
}.freeze

# rubocop:disable Metrics/BlockLength
RSpec.describe Hand do
  context '#initialize' do
    subject { Hand.new(HANDS[:straight_flush]) }
    let(:ranks) { subject.cards.map(&:first).compact }
    let(:suits) { subject.cards.map(&:last).compact }

    it 'initializes the cards' do
      aggregate_failures do
        expect(subject.cards).to be_an Array
        expect(subject.cards[0]).to be_an Array
        expect(subject.cards.length).to eq(5)
      end
    end

    it 'should return 5 cards and suits' do
      aggregate_failures do
        expect(ranks.length).to eq(5)
        expect(suits.length).to eq(5)
      end
    end

    it 'should have sorted integer ranks' do
      expect(ranks).to eq([4, 3, 2, 1, 0])
    end

    it 'should be all hearts' do
      expect(suits.uniq).to eq(%w[H])
    end
  end

  context '#straight?' do
    it 'should be true' do
      expect(Hand.new(HANDS[:straight]).straight?).to be true
    end

    it 'should be false' do
      expect(Hand.new(HANDS[:pair]).straight?).to be false
    end
  end

  context '#flush?' do
    it 'should be true' do
      expect(Hand.new(HANDS[:straight_flush]).flush?).to be true
    end

    it 'should be false' do
      expect(Hand.new(HANDS[:straight]).flush?).to be false
    end
  end

  context '#hand' do
    SCORES.each do |k, v|
      it "should parse a #{k}" do
        expect(Hand.new(HANDS[k]).hand).to eq(v)
      end
    end
  end

  context '#rank_by_card' do
    it 'should be -1' do
      expect(
        Hand.new(HANDS[:high_card]).rank_by_cards(Hand.new(HANDS[:straight]))
      ).to eq(-1)
    end

    it 'should be 1' do
      expect(
        Hand.new(HANDS[:straight]).rank_by_cards(Hand.new(HANDS[:high_card]))
      ).to eq(1)
    end

    it 'should be 0' do
      expect(
        Hand.new(HANDS[:high_card]).rank_by_cards(Hand.new(HANDS[:high_card]))
      ).to eq(0)
    end
  end

  context '#<=>' do
    (0..HANDS.length - 2).each do |i|
      winner = HANDS.keys[i + 1]
      looser = HANDS.keys[i]
      it "a #{winner} should beat a #{looser}" do
        h1 = Hand.new(HANDS[winner])
        h2 = Hand.new(HANDS[looser])
        aggregate_failures do
          expect(h1 <=> h2).to eq(1)
          expect(h1 > h2).to be true
          expect(h1 < h2).to be false
          expect(h1 == h2).to be false
        end
      end
    end

    it 'should return a draw' do
      h1 = Hand.new(HANDS[:pair])
      h2 = Hand.new(HANDS[:pair])
      aggregate_failures do
        expect(h1 <=> h2).to eq(0)
        expect(h1 == h2).to be true
      end
    end
  end
end
