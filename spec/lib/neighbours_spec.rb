require 'active_support'

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/springsense-ruby/neighbours')

describe Neighbours do
  
  before :all do
    @neighbours = Neighbours.from_csv( 
        File.join(
          File.expand_path(File.dirname(__FILE__)), 
          'test_neighbours.csv'
        )
      )
  end
  
  it "should load correctly from file" do
    @neighbours.count.should eql 100
    @neighbours['container_n_01'][0.746999502182].should eql('city_n_01')
  end

  it "should expand correctly" do 
    
    @neighbours.expand('profiling_n_01', 2, 0.8).should eql(
      [
        'identification_n_02',
        'linguistic_profiling_n_01',
      ])
  end
      
end