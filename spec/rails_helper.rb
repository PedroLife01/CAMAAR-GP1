# frozen_string_literal: true
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
# Configuração do shoulda-matchers
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
# ...existing code...

# Devise helpers para controller specs
RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
end

# rails-controller-testing para render_template e assigns
require 'rails-controller-testing'
Rails::Controller::Testing::TestProcess
Rails::Controller::Testing::TemplateAssertions
Rails::Controller::Testing::Integration

# Configuração do FactoryBot para uso dos métodos build/create diretamente
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
