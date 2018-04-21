describe Task, type: :model do
  subject { FactoryBot.create(:task) }

  describe 'Factory' do
    it { is_expected.to be_valid }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:duration) }

    it { is_expected.to validate_numericality_of(:duration).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:duration).is_less_than_or_equal_to(24 * 60) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
  end
end
