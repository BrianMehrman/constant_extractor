RSpec.describe ConstantExtractor do
  it "has a version number" do
    expect(ConstantExtractor::VERSION).not_to be nil
  end

  describe '#process' do
    let(:filepath) { 'spec/examples/simple_constants.rb' }

    it 'extracts the classes and modules from the file' do
      expect(ConstantExtractor.process(filepath).flat_map(&:children)).to eq([:GearRatio, :"GearRatio::Foo", :Gear])
    end
  end
end
