require 'spec_helper'

module TurnipFormatter::Scenario
  describe Pass do
    let(:scenario) { ::TurnipFormatter::Scenario::Pass.new(example) }

    include_context 'turnip_formatter scenario setup', proc {
      expect(true).to be_true
    }

    context 'Turnip example' do
      let(:metadata) do
        {
          steps: { descriptions: ['Step 1'], docstrings: [[]], keywords: ['When'], tags: [] },
          file_path: '/path/to/hoge.feature'
        }
      end

      describe '#validation' do
        it 'should not raise exception' do
          expect { scenario.validation }.not_to raise_error
        end
      end

    end

    context 'Not Turnip example' do
      context 'Not passed example' do
        let(:metadata) do
          {
            steps: { descriptions: ['Step 1'], docstrings: [[]], keywords: ['When'], tags: [] },
            file_path: '/path/to/hoge.feature'
          }
        end

        include_context 'turnip_formatter scenario setup', proc {
          expect(true).to be_false
        }

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NotPassedScenarioError
          end
        end        
      end

      context 'not exist feature file' do
        let(:metadata) do
          {
            steps: { descriptions: ['Step 1'], docstrings: [[]], keywords: ['When'], tags: [] },
            file_path: '/path/to/hoge.rb'
          }
        end

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NoFeatureFileError
          end
        end
      end

      context 'not exist step information' do
        let(:metadata) { { file_path: '/path/to/hoge.rb' } }

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NotExistStepsInformationError
          end
        end
      end
    end
  end
end
