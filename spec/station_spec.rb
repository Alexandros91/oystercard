require 'station'
describe Station do
  subject {described_class.new(name: "Old Street", zone: 1)}

  describe "#zone" do
    it 'tells us what zone the station is in' do
      expect(subject.zone).to eq 1
    end
  end
  
  describe "#name" do
    it 'tells us the name of the station we are in' do
      expect(subject.name).to eq "Old Street"
    end
  end
end