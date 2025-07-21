require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it 'herda de ApplicationController' do
    expect(described_class.superclass).to eq(ApplicationController)
  end
end

