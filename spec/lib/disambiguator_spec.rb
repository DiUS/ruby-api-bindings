require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/springsense-ruby')

describe Disambiguator do

  URL = "https://springsense.p.mashape.com/disambiguate"
  MASHAPE_KEY = ENV['MASHAPE_KEY']

  let(:disambiguator) { Disambiguator.new(MASHAPE_KEY, URL) }

  it "should initialize correctly" do
    disambiguator.url.should == URL
    disambiguator.mashape_key.should == MASHAPE_KEY
  end

  it "should disambiguate correctly" do
    result = disambiguator.disambiguate("cat vet")

    result.should be_a DisambiguatedResult
    result.variants_in_rank_order.size.should == 3
    result.text_variants_in_rank_order.should == ["cat_n_01 veterinarian_n_01", "cat_n_01 veteran_n_02", "big_cat_n_01 veteran_n_02"] 
  end

end