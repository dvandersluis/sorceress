require 'spec_helper'

RSpec.describe Sorceress::Spells::RunScript do
  describe '#initialize' do
    before { allow(Sorceress::Spell::LocateScript).to receive(:find) { |path| path } }

    it 'compacts nil arguments' do
      spell = described_class.new('spell.sh', nil)
      expect(spell.arguments).to be_empty
    end
  end
end
