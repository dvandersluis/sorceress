require 'spec_helper'

RSpec.describe Sorceress::Spellbook do
  let(:arg) { nil }

  subject(:spellbook) { described_class.new(arg) }

  describe '#dependencies' do
    subject { spellbook.dependencies }

    context 'when only using the default config' do
      it 'only has the default dependencies' do
        expect(subject).to eq(
          'brew' => {},
          'ruby' => { 'manager' => 'rbenv' }
        )
      end
    end

    context 'parsing YAML formats' do
      let(:expected) do
        {
          'brew' => {},
          'ruby' => { 'version' => '2.6.5', 'foo' => 'bar', 'manager' => 'rbenv' },
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
            'brew' => {},
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
            'brew' => {},
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
            'brew' => {},
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
            'brew' => {},
            'ruby' => {}
          )
        end
      end
    end

    context 'when supplementing the config' do
      let(:arg) { Sorceress.root.join('.sorceress.yml') }
      let(:expected) do
        {
          'brew' => {},
          'ruby' => { 'version' => '2.6.5', 'manager' => 'rbenv' },
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
