require 'spec_helper'

RSpec.describe Sorceress::Spell::LocateScript do
  describe '.find' do
    context 'when given a command in $PATH' do
      it 'returns it' do
        expect(described_class.find('ls')).to eq('ls')
      end
    end
  end
end
