# combined integration tests on some edge cases
ROUNDS = {
  high_pair: '5D 5H 2D 2H TD 4D 4H 2S 2C AS', # tests value sort
  matched_pair: '4D 4H 2D 2H AH 4S 4C 2S 2C TS',
  high_treys: '5D 5H 5C 2D 3S 4D 4H 4C 2H 3H',
  high_full_boat: '5D 5H 5C 2H 2D 4D 4H 4C 2C 2S',
  high_flush: '2H 3H 4H 5H TH 2D 3D 4D 5D 7D',
}.freeze
LOOSE = '4D 4H 2D 2H AD 5D 5H 2S 2C AS'.freeze

# rubocop:disable Metrics/BlockLength
RSpec.describe Poker do
  subject { Poker.new }
  context '#initialize' do
    it 'should have a file' do
      expect(File.exist?(subject.instance_variable_get('@file'))).to be true
    end
  end

  context '#hand' do
    let(:cards) { ROUNDS[:high_pair].split }
    it 'should get the first hand' do
      expect(subject.send(:hand, cards, 0).length).to eq(5)
    end

    it 'should get the second hand' do
      expect(subject.send(:hand, cards, 1).length).to eq(5)
    end
  end

  context '#round' do
    ROUNDS.each do |k, v|
      it "should win a #{k}" do
        expect(subject.round(v)).to be true
      end
    end

    it 'should loose' do
      expect(subject.round(LOOSE)).to be false
    end
  end

  context '#play' do
    let(:file) { '/tmp/poker.txt' }
    let(:lines) { ROUNDS.values.length + 1 }
    before do
      File.write(
        file, ROUNDS.values.concat([LOOSE]).join("\n")
      )
    end
    subject { Poker.new(file).play }

    it 'should return a two element array' do
      aggregate_failures do
        expect(subject).to be_an Array
        expect(subject.length).to eq(2)
      end
    end

    it 'should have the correct number of rounds' do
      expect(subject[0]).to eq(lines)
    end

    it 'should have the correct number of winners' do
      expect(subject[1]).to eq(lines - 1)
    end
  end
end
