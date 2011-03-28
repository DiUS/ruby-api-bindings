# Convert a integer value to English.
module EasyAccessHash

  def method_missing(key, *args)
    key_s = key.to_s
    if (key_s =~ /^(.*)=$/) then
      # assignment
      value = store($1, args.first)
    else
      # treat as get if key exists
      value = self[key_s] || self[key]

      super(key, *args) if value.nil?

      value
    end
  end

end

class Hash
  include EasyAccessHash
end
