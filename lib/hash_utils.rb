module HashUtils
  def self.to_url_params(hash = {})
    elements = []
    hash.keys.size.times do |i|
      elements << "#{hash.keys[i]}=#{hash.values[i]}"
    end
    elements.join('&')
  end
end
