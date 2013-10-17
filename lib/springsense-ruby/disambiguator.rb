require 'uri'
require 'net/http'
require 'mashape'

require File.expand_path('disambiguated_result', File.dirname(__FILE__))

class Disambiguator

  attr_reader :mashape_key
  attr_reader :url

  def initialize(mashape_key,  url)
    @mashape_key = mashape_key
    @authentication_handlers = mashape_key.nil? ? [] : [ Mashape::MashapeAuthentication.new(mashape_key) ]
    @url = url
  end

  def disambiguate(text)
    response = Mashape::HttpClient.do_request(:get, url, { "body" => text }, :form, :json, authentication_handlers)
    result = DisambiguatedResult.from_response(response.raw_body)

    result.text_variants_in_rank_order

    result
  end

  private

  def authentication_handlers
    @authentication_handlers
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