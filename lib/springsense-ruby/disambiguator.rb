require 'uri'
require 'net/http'
require 'mashape'

require File.expand_path('disambiguated_result', File.dirname(__FILE__))

class Disambiguator

  attr_reader :public_key
  attr_reader :private_key
  attr_reader :url

  def initialize(public_key, private_key, url)
    @public_key = public_key
    @private_key = private_key
    @url = url
  end

  def disambiguate(text)
    response = Mashape::HttpClient.do_request(:get, url, { body: text }, :form, :json, authentication_handlers)
    result = DisambiguatedResult.from_response(response.raw_body)

    result.text_variants_in_rank_order

    result
  end

  private

  def authentication_handlers
    @authentication_handlers ||= [ Mashape::MashapeAuthentication.new(public_key, private_key) ]
  end

  def prepare_text(text)
    text.split(/\n/).join('. ')
  end

  def call_service(text)
    return 
  rescue => e
    raise "Disambiguator #{url} - Error while disambiguating '#{text}': #{e}"
  end

end