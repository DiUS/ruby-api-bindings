require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/springsense-ruby')

describe Disambiguator do

  URL = "http://api.springsense.com:8081/v1/disambiguate"
  APP_ID = "0b331fdb"
  APP_KEY = "c1f02a931ae759f8d6584812ef9e1859"

  let(:disambiguator) { Disambiguator.new(APP_ID, APP_KEY, URL) }

  it "should initialize correctly" do
    disambiguator.url.should == URL
    disambiguator.app_id.should == APP_ID
    disambiguator.app_key.should == APP_KEY
  end

  it "should disambiguate correctly" do
    result = disambiguator.disambiguate("cat vet")

    result.should be_a DisambiguatedResult
    result.variants_in_rank_order.size.should == 3
    result.text_variants_in_rank_order.should == ["cat_n_01 veterinarian_n_01", "big_cat_n_01 veteran_n_02", "big_cat_n_01 veterinarian_n_01"]
  end

end