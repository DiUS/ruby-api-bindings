require File.expand_path('disambiguated_result', File.dirname(__FILE__))

class Disambiguator

  attr_reader :address
  attr_reader :port

  attr_reader :customer_id
  attr_reader :api_key

  def initialize(customer_id, api_key, address, port = 3001)
    @customer_id = customer_id
    @api_key = api_key
    @address = address
    @port = port
  end

  def disambiguate(text)
    response = call_service(prepare_text(text))

    result = DisambiguatedResult.from_response(response)

    result.text_variants_in_rank_order

    result
  end

  private

  def prepare_text(text)
    text.split(/\n/).join('. ')
  end

  def call_service(text)
    Net::HTTP.start(@address, @port) do |client|
      client.open_timeout = 120
      client.read_timeout = 120
      client.post("/disambiguate?customer_id=#{self.customer_id}&api_key=#{self.api_key}", text).body
    end
  rescue => e
    raise "Disambiguator #{@address}:#{@port} - Error while disambiguating '#{text}': #{e}"
  end

end