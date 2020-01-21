require 'spec_helper'

RSpec.describe Sorceress::Spellbook do
  let(:arg) { nil }
  let(:default_spellbook) { { 'dependencies' => dependencies } }
  let(:dependencies) { { 'brew' => {}, 'ruby' => {} } }

  subject(:spellbook) { described_class.new(arg) }

  before { allow(spellbook).to receive(:default_spellbook).and_return(default_spellbook) }

  describe '#dependencies' do
    subject { spellbook.dependencies }

    context 'when only using the default config' do
      it 'only has the default dependencies' do
        expect(subject).to eq(
          'brew' => {},
          'ruby' => {}
        )
      end
    end

    context 'parsing YAML formats' do
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
        let(:arg) { Sorceress.root.join('spec/spellbooks/dep-hash.yml') }

        it 'merges the given config' do
          expect(subject).to eq(expected)
        end
      end

      context 'array of hashes' do
        let(:arg) { Sorceress.root.join('spec/spellbooks/dep-array.yml') }

        it 'merges the given config' do
          expect(subject).to eq(expected)
        end
      end

      context 'array with malformed hashes' do
        let(:arg) { Sorceress.root.join('spec/spellbooks/dep-array-malformed.yml') }

        it 'merges the given config' do
          expect(subject).to eq(expected)
        end
      end
    end

    context 'deep merge' do
      let(:dependencies) { { 'ruby' => { 'manager' => 'rbenv' } } }

      context 'when there is no nested conflicting key' do
        let(:arg) do
          {
            'dependencies' => {
              'ruby' => { 'version' => '2.6.5' }
            }
          }
        end

        it 'merges the given config' do
          expect(subject).to eq(
            'ruby' => { 'version' => '2.6.5', 'manager' => 'rbenv' }
          )
        end
      end

      context 'when there is a nested conflict' do
        let(:arg) do
          {
            'dependencies' => {
              'ruby' => { 'manager' => 'chruby' }
            }
          }
        end

        it 'merges the given config' do
          expect(subject).to eq(
            'ruby' => { 'manager' => 'chruby' }
          )
        end
      end

      context 'when there is a nil key' do
        let(:arg) do
          {
            'dependencies' => {
              'ruby' => { 'manager' => nil }
            }
          }
        end

        it 'ignores it' do
          expect(subject).to eq(
            'ruby' => {}
          )
        end
      end

      context 'when there is a key with a none value' do
        let(:arg) do
          {
            'dependencies' => {
              'ruby' => { 'manager' => 'none' }
            }
          }
        end

        it 'ignores it' do
          expect(subject).to eq(
            'ruby' => {}
          )
        end
      end
    end

    context 'when supplementing the config' do
      before { allow(spellbook).to receive(:default_spellbook).and_call_original }

      let(:arg) { Sorceress.root.join('.sorceress.yml') }
      let(:expected) do
        {
          'brew' => {},
          'ruby' => {
            'version' => '2.6.5',
            'dependencies' => {
              'manager' => %w(rbenv rvm chruby asdf)
            }
          },
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
