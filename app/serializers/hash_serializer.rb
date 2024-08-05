class HashSerializer
  def self.dump(hash)
    if hash.class ==  String
      hash.to_json
    else
      hash
    end
  end

  def self.load(hash)
    (hash || {}).with_indifferent_access
  end
end
