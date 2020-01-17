require 'spec_helper'

RSpec.describe Sorceress::Config do
  let(:config_file) { nil }

  subject { described_class.new(config_file) }

  describe '#dependencies' do
    subject { super().dependencies }

    context 'when only using the default config' do
      it 'only has the default dependencies' do
        expect(subject).to eq(
          'brew' => {},
          'ruby' => {}
        )
      end
    end

    context 'handling config formats' do
      let(:expected) do
        {
          'brew' => {},
          'ruby' => { 'version' => '2.6.5', 'foo' => 'bar' },
          'mysql' => { 'version' => '~> 8.0.17' },
          'elasticsearch' => { 'version' => '~> 7.3.2' },
          'foo' => {}
        }
      end

      context 'hash' do
        let(:config_file) { Sorceress.root.join('spec/support/dep-hash.yml') }

        it 'merges the given config' do
          expect(subject).to eq(expected)
        end
      end

      context 'array of hashes' do
        let(:config_file) { Sorceress.root.join('spec/support/dep-array.yml') }

        it 'merges the given config' do
          expect(subject).to eq(expected)
        end
      end

      context 'array with malformed hashes' do
        let(:config_file) { Sorceress.root.join('spec/support/dep-array-malformed.yml') }

        it 'merges the given config' do
          expect(subject).to eq(expected)
        end
      end
    end

    context 'when supplementing the config' do
      let(:config_file) { Sorceress.root.join('spec/support/sorceress.yml') }
      let(:expected) do
        {
          'brew' => {},
          'ruby' => { 'version' => '2.6.5' },
          'mysql' => { 'version' => '~> 8.0.17' },
          'elasticsearch' => { 'version' => '~> 7.3.2' }
        }
      end

      it 'merges the given config' do
        expect(subject).to eq(expected)
      end
    end
  end
end
