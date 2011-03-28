require File.expand_path('easy_access_hash', File.dirname(__FILE__))

class DisambiguatedResult 
  attr_reader :original

  NUMBER_OF_VARIANTS = 3

  def self.from_response(response)

    begin
      response_json = ActiveSupport::JSON.decode(response);
    rescue Exception => e
      puts "Error while processing the following response:\n---\n#{response}\n---\n"

      raise e
    end

    return DisambiguatedResult.new( response_json )
  end

  def clear_for_gc
    @original = nil
  end

  def text_variants_in_rank_order()
    s = sentences
    Array.new(NUMBER_OF_VARIANTS) do | i |
      s.map do | sentence |
        DisambiguatedResult.get_best_element(sentence.sentence_variants, i)
      end.join("\n")
    end
  end

  def variants_in_rank_order()
    s = sentences
    Array.new(NUMBER_OF_VARIANTS) do | i |
      s.map do | sentence |
        DisambiguatedResult.get_best_element(sentence.variants, i)
      end.join("\n")
    end
  end

  def sentences
    original.map { | sentence_original | DisambiguatedSentence.new(sentence_original) }
  end

  private

  def initialize(original)
    @original = original
  end

  def self.get_best_element(array, index)
    return array[0] if index >= array.size

    return array[index]
  end

end

class DisambiguatedSentence
  attr_reader :original

  def initialize(original)
    @original = original
  end

  def scores
    original.scores
  end

  def variants
    original.terms.map do | term |
      ( term.meanings.blank? ? Array.new(scores.size > 0 ? scores.size : 1) { term.except('meanings') } : Array.new(scores.size) { | i | clone = term.except('meanings'); clone.meaning = term.meanings[i].meaning; clone.definition = term.meanings[i].definition; clone } ).flatten
    end.transpose
  end

  def variants_text
    original.terms.map do | term |
      ( term.meanings.blank? ? [ Array.new(scores.size) { term.word } ] : term.meanings.map { | h | h.meaning } ).flatten
    end
  end

  def sentence_variants
    variants_text.transpose.map { | s | s.join(' ') }
  end

end