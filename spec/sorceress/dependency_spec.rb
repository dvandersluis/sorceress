require 'spec_helper'

RSpec.describe Sorceress::Dependency do
  let(:which) { '/Home/.rbenv/versions/2.7.0/bin/ruby' }
  let(:version) { '2.6.5' }
  let(:requirements) { nil }

  subject(:dependency) { described_class.new('ruby', *requirements) }

  before do
    allow(dependency).to receive(:which).and_return(which)
    allow(dependency).to receive(:find_version).and_return(version)
  end

  describe '#executable' do
    subject { dependency.executable }

    it 'returns the path to the executable' do
      expect(subject).to eq(which)
    end

    context 'when the executable cannot be found' do
      let(:which) { '' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#local_version' do
    subject { dependency.local_version }

    context 'when the executable cannot be found' do
      let(:which) { '' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the version is blank' do
      let(:version) { '' }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the version is a.b.c' do
      let(:version) { '1.2.3' }

      it 'returns the version' do
        expect(subject).to eq('1.2.3')
      end
    end

    context 'when the version is a.b.cp0' do
      let(:version) { '1.2.3p0' }

      it 'strips the patchlevel' do
        expect(subject).to eq('1.2.3')
      end
    end

    context 'when the version is in a string' do
      let(:version) { 'The version is 1.2.3 (foo bar baz)' }

      it 'returns only the version string' do
        expect(subject).to eq('1.2.3')
      end
    end
  end

  describe '#requirement_met?' do
    subject { dependency.requirement_met? }

    context 'when the executable cannot be found' do
      let(:which) { '' }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when there are no requirements' do
      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when there is an exact requirement' do
      let(:requirements) { ['2.6.5'] }

      context 'when the version matches' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version does not match' do
        let(:version) { '2.6.6' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'when there is an exact requirement' do
      let(:requirements) { ['= 2.6.5'] }

      context 'when the version matches' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version does not match' do
        let(:version) { '2.6.6' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'when there is a disallowed version' do
      let(:requirements) { ['!= 2.6.5'] }

      context 'when the version matches' do
        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when the version does not match' do
        let(:version) { '2.6.6' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end

    context 'when the requirement is >' do
      let(:requirements) { ['> 2.6.5'] }

      context 'when the version matches' do
        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when the version is greater' do
        let(:version) { '2.6.6' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version is lesser' do
        let(:version) { '2.6.4' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'when the requirement is >=' do
      let(:requirements) { ['>= 2.6.5'] }

      context 'when the version matches' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version is greater' do
        let(:version) { '2.6.6' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version is lesser' do
        let(:version) { '2.6.4' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'when the requirement is <' do
      let(:requirements) { ['< 2.6.5'] }

      context 'when the version matches' do
        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when the version is greater' do
        let(:version) { '2.6.6' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when the version is lesser' do
        let(:version) { '2.6.4' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end

    context 'when the requirement is <=' do
      let(:requirements) { ['<= 2.6.5'] }

      context 'when the version matches' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version is greater' do
        let(:version) { '2.6.6' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when the version is lesser' do
        let(:version) { '2.6.4' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end
    end

    context 'when the requirement is ~>' do
      let(:requirements) { ['~> 2.6.5'] }

      context 'when the version matches' do
        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version is greater' do
        let(:version) { '2.6.6' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when the version is lesser' do
        let(:version) { '2.6.4' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when the minor version is greater' do
        let(:version) { '2.7.2' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'when multiple requirements are given' do
      let(:requirements) { ['~> 2.6.4', '< 2.6.10'] }

      context 'when all requirements are met' do
        let(:version) { '2.6.5' }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'when only some requirements are met' do
        let(:version) { '2.6.10' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end

      context 'when no requirements are met' do
        let(:version) { '2.7.0' }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end

    context 'when conflicting requirements are given' do
      let(:requirements) { ['< 2.6', '> 2.7'] }

      it 'always returns false' do
        expect(subject).to eq(false)
      end
    end
  end
end
