require 'adhearsion'
require 'sequella'

unless ENV['SKIP_RCOV']
  require 'simplecov'
  require 'simplecov-rcov'
  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start do
    add_filter "/vendor/"
    add_filter "/spec/"
  end
end

RSpec.configure do |config|
  config.color_enabled = true
  config.tty = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

