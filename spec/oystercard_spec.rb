require 'oystercard'

describe Oystercard do

  let(:station){ double :station}

  it 'initializes new card' do
    expect(Oystercard.new).to be_an_instance_of(Oystercard)
  end

  it 'sets new card to 0 balance' do 
    new_oyster = Oystercard.new
    expect(new_oyster.balance).to eq(0)
  end

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

  it "deducts fare from balance" do
    oyster = Oystercard.new
    oyster.top_up(70)
    oyster.send(:deduct, 10)
    expect(oyster.balance).to eq(60)
  end

  it 'responds to touch_in method' do
    expect(Oystercard.new).to respond_to(:touch_in).with(1).argument
  end

  it 'status changes to true when card touched in' do
    oyster = Oystercard.new
    oyster.top_up(5)
    oyster.touch_in(station)
    expect(oyster.status).to eq(true) 
  end

  it 'responds to touch_out method' do
    expect(Oystercard.new).to respond_to(:touch_out)
  end

  it 'status changes to false when card touched out' do
    oyster = Oystercard.new
    expect(oyster.status).to eq(false)
  end

  it 'raises error at touch_in if card already in use' do
    oyster = Oystercard.new
    oyster.top_up(5)
    oyster.touch_in(station)
    expect(oyster).to be_in_journey
  end

  it 'raises error at touch_out if card is not in use' do
    oyster = Oystercard.new
    expect(oyster).not_to be_in_journey
  end

  it "raises error if oystercard gets touched in with balance less than £1" do
    oyster = Oystercard.new
    expect{ oyster.touch_in(station) }.to raise_error("Balance is less than £1")
  end

  it "reducts balance by the minimum charge when it is touched out" do
    oyster = Oystercard.new
    oyster.top_up(10)
    oyster.touch_in(station)
    expect{ oyster.touch_out}. to change { oyster.balance }.by(-Oystercard::MINIMUM_AMOUNT)
  end

  it 'stores the entry station' do
    subject.top_up(10)
    subject.touch_in(station)
    expect(subject.entry_station).to eq station
  end  

end