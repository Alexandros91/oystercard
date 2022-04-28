require 'journey'
describe Journey do
  let(:station) {double :station, zone: 1}
  subject {described_class.new(station: station)}
  
  it 'knows if a journey is not complete' do
    expect(subject).not_to be_complete
  end

  it 'has a penalty fare by default' do
    expect(subject.fare).to eq(Journey::PENALTY_FARE)
  end

  it 'returns itself when exiting a journey' do
    expect(subject.finish(station)).to eq subject
  end
end
