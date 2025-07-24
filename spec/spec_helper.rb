# frozen_string_literal: true
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  track_files 'app/models/**/*.rb'
  track_files 'app/controllers/**/*.rb'
  add_filter do |src|
    !src.filename.start_with?(File.join(SimpleCov.root, 'app', 'models')) &&
    !src.filename.start_with?(File.join(SimpleCov.root, 'app', 'controllers'))
  end
end

# ...existing code...
