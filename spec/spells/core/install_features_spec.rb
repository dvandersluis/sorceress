# rubocop:disable RSpec/MessageSpies
require 'spec_helper'

RSpec.describe Sorceress::Spells::Core::InstallFeatures do
  let(:features) { [dependency] }
  let(:invoked_spells) { [] }
  let(:last_spell) { invoked_spells.last }

  before do
    allow(subject).to receive(:features).and_return(features)

    allow(subject).to receive(:spell_for).and_wrap_original do |method, *args|
      method.call(*args).tap do |spell|
        allow(spell).to receive(:call)
        invoked_spells << spell
      end
    end
  end

  describe '#call' do
    context 'when there are no features to install' do
      let(:features) { [] }

      it 'does nothing' do
        expect(subject).to_not receive(:spell_for)
        subject.call
      end
    end

    context 'when the feature has a ruby install class' do
      let(:dependency) { double('Sorceress::Dependency', name: 'ruby', install_version: '2.7.0') }

      it 'invokes it' do
        subject.call
        expect(last_spell).to be_a(Sorceress::Spells::Install::Ruby)
        expect(last_spell).to have_received(:call)
      end
    end

    context 'when the feature has a shell install script', mock_shell_locate: true do
      let(:dependency) { double('Sorceress::Dependency', name: 'abc', install_version: '1.2.3') }

      it 'invokes it' do
        subject.call
        expect(last_spell).to be_a(Sorceress::Spells::RunScript)
        expect(last_spell.script_path).to eq('install/abc.sh')
        expect(last_spell.arguments).to eq(%w(1.2.3))
        expect(last_spell).to have_received(:call)
      end
    end

    context 'when the feature does not have an install script' do
      let(:dependency) { double('Sorceress::Dependency', name: 'abc', install_version: '1.2.3') }

      it 'invokes the default install script' do
        subject.call
        expect(last_spell).to be_a(Sorceress::Spells::RunScript)
        expect(last_spell.script_path.to_s).to end_with('core/install.sh')
        expect(last_spell.arguments).to eq(%w(abc 1.2.3))
        expect(last_spell).to have_received(:call)
      end
    end
  end
end
# rubocop:enable RSpec/MessageSpies
