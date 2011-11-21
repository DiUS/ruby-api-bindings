require File.expand_path('easy_access_hash', File.dirname(__FILE__))
require 'active_support'

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
    result = []
    original.terms.map do | term | 
      (Array.new(scores.size > 0 ? scores.size : 1) { | i | ResolvedTerm.new(term, i) }).flatten
    end.transpose.each_with_index { | array_of_resolved_terms, i | result << ResolvedSentence.new(array_of_resolved_terms, scores[i], i)  } 
    
    result
  end

  def variants_text
    variants.map() do | variant |
       variant.map(&:to_s)
    end
  end

  def is_type?(meaning)
    ["person_n_01", "association_n_01", "location_n_01"].include?(meaning)
  end

  def sentence_variants
    variants_text.map { | s | s.join(' ') }
  end

end

class ResolvedSentence < Array
  attr_accessor :score
  attr_accessor :index
  
  def initialize(resolved_terms, score, i)
    super()
    
    self.push(*resolved_terms)
    @score = score
    @index = i
  end
  
end

class ResolvedTerm < Hash
  
  def initialize(term, i)
    super()
    
    self.merge!(term.except('meanings'))
    
    if (term.meanings.count > i)
      self.meaning = term.meanings[i].meaning; 
      self.definition = term.meanings[i].definition;
    end
    
    self
  end
  
  def to_s()
    return self.word unless has_meaning?
    
    return self.word.gsub(/_/, ' ') if is_type?
    
    self.meaning
  end
  
  def has_meaning?()
    !self['meaning'].blank?
  end

  def is_type?
    ["person_n_01", "association_n_01", "location_n_01"].include?(self.meaning.to_s)
  end
end