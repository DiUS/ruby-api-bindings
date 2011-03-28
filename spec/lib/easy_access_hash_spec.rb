# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../lib/easy_access_hash')

describe EasyAccessHash do

  it "should allow access an array of hashes of hashes hierarchy" do

    input = [ { :a => :b }, { 'c' => { :d => :e } }, [ { :f => [ :g, :h, :i ] } ] ]

    output =  (input)

    output.size.should == 3

    first = output.first

    first.a.should_not be_nil
    first.a.should eql(:b)

    second = output[1]
    second.c.d.should eql(:e)

    third = output[2]
    third.size.should == 1
    third.first.f.should eql([ :g, :h, :i ])
  end

end
  
