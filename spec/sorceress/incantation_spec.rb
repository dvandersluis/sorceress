require 'spec_helper'

RSpec.describe Sorceress::Incantation do
  let(:spellbook) { double('Spellbook', steps: steps) }
  let(:steps) { [] }

  before { allow(Sorceress).to receive(:spellbook).and_return(spellbook) }

  context 'with an empty spellbook' do
    it 'does nothing' do
      expect(subject).to_not receive(:invoke_spell)
      subject.call
    end
  end

  context 'with a missing step' do
    let(:steps) { %w(missing) }

    it 'raises Sorceress::SpellNotFound' do
      expect { subject.call }.to raise_error Sorceress::SpellNotFound
    end
  end

  context 'with an invalid spell' do
    before { stub_const('Spell', Class.new) }

    let(:steps) { %w(spell) }

    it 'raises Sorceress::InvalidSpell' do
      expect { subject.call }.to raise_error Sorceress::InvalidSpell
    end
  end

  context 'with valid spells' do
    let(:steps) { %w(core/find_dependencies core/install_features) }

    it 'invokes each spell' do
      expect(subject).to receive(:invoke_spell).with(Sorceress::Spells::Core::FindDependencies)
      expect(subject).to receive(:invoke_spell).with(Sorceress::Spells::Core::InstallFeatures)
      subject.call
    end
  end

  context 'with a valid custom spell' do
    before { stub_const('Spell', Class.new(Sorceress::Spell)) }

    let(:steps) { %w(spell) }

    it 'invokes it' do
      expect(subject).to receive(:invoke_spell).with(Spell)
      subject.call
    end
  end

  context 'with a shell spell' do
    let(:steps) { %w(my_script) }

    before do
      allow(Sorceress::Spell).to receive(:shell_script).with('my_script').and_return('my_script.sh')
    end

    it 'invokes it' do
      expect(subject).to receive(:invoke_spell).with(Sorceress::Spells::RunScript)
      subject.call
    end
  end
end
