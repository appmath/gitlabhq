require 'spec_helper'

describe Ci::Variable, models: true do
  subject { build(:ci_variable) }

  it { is_expected.to be_kind_of(HasVariable) }
  it { is_expected.to validate_uniqueness_of(:key).scoped_to(:project_id) }

  describe '.unprotected' do
    subject { described_class.unprotected }

    context 'when variable is protected' do
      before do
        create(:ci_variable, :protected)
      end

      it 'returns nothing' do
        is_expected.to be_empty
      end
    end

    context 'when variable is not protected' do
      let(:variable) { create(:ci_variable, protected: false) }

      it 'returns the variable' do
        is_expected.to contain_exactly(variable)
      end
    end
  end
end
