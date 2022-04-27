require 'oystercard'

describe Oystercard do

  let(:entry_station){ double :station}
  let(:exit_station){ double :station}

  it 'sets new card to 0 balance' do 
    new_oyster = Oystercard.new
    expect(new_oyster.balance).to eq(0)
  end

  describe "#top_up" do
    it "tops up card with balance" do
      oyster = Oystercard.new
      expect{ oyster.top_up(10) }.to change{ oyster.balance }.by(10)
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_CAPACITY
      subject.top_up maximum_balance
      expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe "#touch_in" do
    it 'changes the journey status to be in use' do
      oyster = Oystercard.new
      oyster.top_up(5)
      oyster.touch_in(entry_station)
      expect(oyster.in_journey?).to eq(true) 
    end

    it 'raises error at touch_in if card already in use' do
      oyster = Oystercard.new
      oyster.top_up(5)
      oyster.touch_in(entry_station)
      expect(oyster).to be_in_journey
    end

    it "raises error if oystercard gets touched in with balance less than £1" do
      oyster = Oystercard.new
      expect{ oyster.touch_in(entry_station) }.to raise_error("Balance is less than £1")
    end
  end

  describe "#touch_out" do
    it 'changes the journey status to not be in use' do
      oyster = Oystercard.new
      expect(oyster.in_journey?).to eq(false)
    end
  
    it 'raises error at touch_out if card is not in use' do
      oyster = Oystercard.new
      expect(oyster).not_to be_in_journey
    end

    it "reduces balance by the minimum charge when it is touched out" do
      oyster = Oystercard.new
      oyster.top_up(10)
      oyster.touch_in(entry_station)
      expect{ oyster.touch_out(exit_station)}. to change { oyster.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end

  describe "#history" do
    it 'has an empty list of journeys by default' do
      expect(subject.history).to be_empty
    end

    it 'stores a completed journey' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.history).to eq [{entry_station: entry_station, exit_station: exit_station}]
    end
  end
end