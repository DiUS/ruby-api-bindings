require 'csv'

class Neighbours < Hash
  
  def initialize(csv_file_path)
    load_from_csv(csv_file_path)
  end
  
  def load_from_csv(csv_file_path)
    CSV.foreach(csv_file_path) do |row|
      unless (row.empty?)
        key = rekey(row.shift)
        nouns = {}
        until (row.empty?) or (row.count < 2) 
          noun = rekey(row.shift)
          distance = row.shift.to_f
          nouns[distance] = noun
        end
        self[key] = nouns
      end
    end
  end
  
  def expand(noun, max_expansions, max_radius)
    nouns_for = self[noun]
    return [] if nouns_for.nil?
    
    expanded = []
    
    nouns_for.each_pair do | distance, noun |
      break if expanded.count >= max_expansions
      
      expanded << noun if (distance <= max_radius)
    end
    
    expanded
  end
  
  private
  def rekey(key)
    key.gsub(/\.n\./, '_n_')
  end
end