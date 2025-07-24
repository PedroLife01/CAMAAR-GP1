require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'associações' do
    it { should belong_to(:user).with_foreign_key(:id_user) }
    it { should have_many(:formularios).with_foreign_key(:id_template).dependent(:destroy) }
  end
end
