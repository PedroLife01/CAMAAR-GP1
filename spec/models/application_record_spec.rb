require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  it 'herda de ActiveRecord::Base' do
    expect(described_class < ActiveRecord::Base).to be true
  end
end
