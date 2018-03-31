class Hasher
  
  # calculate hash value for a line
  # returns hash as base 16 string
  def create_hash input
    if !input.is_a? String
      puts "Invalid hash format"
      exit()
    end
            
    input = input.split("")
  
    input = input.map { |value| calculate value }  
    total = input.reduce(:+)
      
    hash = total % 65536
    hash.to_s(16)
  end
  
  # returns calculated value for a character
  def calculate character
    character = character.unpack('U*').first
    character = (character ** 2000) * ((character + 2) ** 21) - ((character + 5) ** 3)
  end
  
end