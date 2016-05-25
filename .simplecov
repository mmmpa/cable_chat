if ENV['CI']
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[Coveralls::SimpleCov::Formatter]
else
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
end

SimpleCov.start 'rails' do
  add_filter '/lib/'
  add_filter '/spec/'
end
