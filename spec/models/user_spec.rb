describe User, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_numericality_of(:preferred_working_hours_per_day).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:preferred_working_hours_per_day).is_less_than_or_equal_to(24 * 60) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:authentication_tokens).dependent(:delete_all) }
    it { is_expected.to have_many(:tasks).dependent(:delete_all) }
  end
end
