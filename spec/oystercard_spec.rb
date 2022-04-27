require 'oystercard'

describe Oystercard do

  let(:entry_station){ double :station}
  let(:exit_station){ double :station}

  it 'initializes new card' do
    expect(Oystercard.new).to be_an_instance_of(Oystercard)
  end

  it 'sets new card to 0 balance' do 
    new_oyster = Oystercard.new
    expect(new_oyster.balance).to eq(0)
  end
  describe "#top_up" do
    it "tops up card with balance" do
      oyster = Oystercard.new
      oyster.top_up(10)
      expect(oyster.balance).to eq(10)
    end

    it 'raises an error if the maximum balance it exceeded' do
      maximum_balance = Oystercard::MAXIMUM_CAPACITY
      subject.top_up maximum_balance
      expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe "#touch_in" do
    it 'responds to touch_in method' do
      expect(Oystercard.new).to respond_to(:touch_in).with(1).argument
    end

    it 'status changes to true when card touched in' do
      oyster = Oystercard.new
      oyster.top_up(5)
      oyster.touch_in(entry_station)
      expect(oyster.status).to eq(true) 
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
    it 'responds to touch_out method' do
      expect(Oystercard.new).to respond_to(:touch_out)
    end

    it 'status changes to false when card touched out' do
      oyster = Oystercard.new
      expect(oyster.status).to eq(false)
    end
  
    it 'raises error at touch_out if card is not in use' do
      oyster = Oystercard.new
      expect(oyster).not_to be_in_journey
    end

    it "reducts balance by the minimum charge when it is touched out" do
      oyster = Oystercard.new
      oyster.top_up(10)
      oyster.touch_in(entry_station)
      expect{ oyster.touch_out(exit_station)}. to change { oyster.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end
  

  it 'stores the entry station' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    expect(subject.entry_station).to eq entry_station
  end 

  it 'stores the exit station' do
    subject.top_up(10)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.exit_station).to eq exit_station
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