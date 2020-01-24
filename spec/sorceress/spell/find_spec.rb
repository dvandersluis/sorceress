require 'spec_helper'

RSpec.describe Sorceress::Spell::Find do
  subject(:klass) { Class.new { extend Sorceress::Spell::Find } }

  before(shell: true) do
    allow(Sorceress::Spell::LocateScript).to receive(:find) do |name|
      name.end_with?('.sh') ? name : "#{name}.sh"
    end
  end

  describe '#find' do
    subject { klass.find(spell) }

    context 'if the spell does not exist' do
      let(:spell) { 'foo' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'if the spell is not valid' do
      before { stub_const('Spell', Class.new) }

      let(:spell) { 'spell' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'with a valid ruby spell' do
      let(:spell) { 'core/install_features' }

      it 'returns the spell class' do
        expect(subject).to be_a(Sorceress::Spells::Core::InstallFeatures)
      end
    end

    context 'with a valid shell spell', shell: true do
      let(:spell) { 'my_script' }

      it 'invokes it' do
        expect(subject).to be_a(Sorceress::Spells::RunScript)
        expect(subject.script_path).to eq('my_script.sh')
        expect(subject.arguments).to be_empty
      end
    end

    context 'with a valid shell spell and arguments', shell: true do
      subject { klass.find('my_script', shell_args: %w(foo bar)) }

      it 'invokes it' do
        expect(subject).to be_a(Sorceress::Spells::RunScript)
        expect(subject.script_path).to eq('my_script.sh')
        expect(subject.arguments).to eq(%w(foo bar))
      end
    end
  end

  describe '#find!' do
    subject { klass.find!(spell) }

    context 'if the spell does not exist' do
      let(:spell) { 'foo' }

      it 'raises SpellNotFound' do
        expect { subject }.to raise_error Sorceress::SpellNotFound
      end
    end

    context 'if the spell is not valid' do
      before { stub_const('Spell', Class.new) }

      let(:spell) { 'spell' }

      it 'raises Sorceress::InvalidSpell' do
        expect { subject }.to raise_error Sorceress::InvalidSpell
      end
    end

    context 'with a valid ruby spell' do
      let(:spell) { 'core/install_features' }

      it 'returns the spell class' do
        expect(subject).to be_a(Sorceress::Spells::Core::InstallFeatures)
      end
    end

    context 'with a valid shell spell', shell: true do
      let(:spell) { 'my_script' }

      it 'invokes it' do
        expect(subject).to be_a(Sorceress::Spells::RunScript)
        expect(subject.script_path).to eq('my_script.sh')
      end
    end

    context 'with a valid shell spell and arguments', shell: true do
      subject { klass.find!('my_script', shell_args: %w(foo bar)) }

      it 'invokes it' do
        expect(subject).to be_a(Sorceress::Spells::RunScript)
        expect(subject.script_path).to eq('my_script.sh')
        expect(subject.arguments).to eq(%w(foo bar))
      end
    end
  end
end
