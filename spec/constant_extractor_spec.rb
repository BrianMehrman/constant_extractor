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

  describe 'ConstructorProcessor#process' do
    let(:filepath) { 'spec/examples/single_class.rb' }
    let(:ruby_code) { File.read(filepath) }
    let(:ast) { Parser::CurrentRuby.parse(ruby_code, filepath) }

    subject { ConstantExtractor::ConstructorProcessor }

    context 'with single class' do
      it 'extracts the class the file' do
        expect(subject.process(ast).flat_map(&:children)).to eq([:Gear])
      end
    end

    context 'with single module' do
      let(:filepath) { 'spec/examples/single_module.rb' }

      it 'extracts the module the file' do
        expect(subject.process(ast).flat_map(&:children)).to eq([:Circle])
      end
    end

    context 'with simple constants' do
      let(:filepath) { 'spec/examples/simple_constants.rb' }

      it 'extracts the classes and modules from the file' do
        expect(subject.process(ast).flat_map(&:children)).to eq([:GearRatio, :"GearRatio::Foo", :Gear])
      end
    end

    context 'with namespaced constants' do
      let(:filepath) { 'spec/examples/namespaced_constants.rb' }

      it 'extracts the classes and modules from the file' do
        expect(subject.process(ast).flat_map(&:children)).to eq([
          :Space,
          :"Space::ModuleA",
          :"Space::ModuleB",
          :"Space::ModuleC",
          :"Space::RootClass",
          :"Space::BaseTest",
          :"Space::Test"
        ])
      end
    end
  end
end
