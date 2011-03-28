# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir::glob(File.join(File.dirname(__FILE__), "support/**/*.rb")).each {|f| require f}

RSpec.configure do |config|
end
