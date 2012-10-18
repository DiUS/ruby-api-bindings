require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/springsense-ruby')

describe Disambiguator do

  URL = "https://springsense.p.mashape.com/disambiguate"
  PUBLIC_KEY = ENV['MASHAPE_PUBLIC_KEY']
  PRIVATE_KEY = ENV['MASHAPE_PRIVATE_KEY']

  let(:disambiguator) { Disambiguator.new(PUBLIC_KEY, PRIVATE_KEY, URL) }

  it "should initialize correctly" do
    disambiguator.url.should == URL
    disambiguator.public_key.should == PUBLIC_KEY
    disambiguator.private_key.should == PRIVATE_KEY
  end

  it "should disambiguate correctly" do
    result = disambiguator.disambiguate("cat vet")

    result.should be_a DisambiguatedResult
    result.variants_in_rank_order.size.should == 3
    result.text_variants_in_rank_order.should == ["cat_n_01 veterinarian_n_01", "big_cat_n_01 veteran_n_02", "big_cat_n_01 veterinarian_n_01"]
  end

end