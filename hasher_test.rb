require 'minitest/autorun'
require_relative 'hasher'

# unit testing for hasher.rb

class HasherTest < Minitest::Test
  
  # UNIT TESTS FOR METHOD create_hash input 
  # Success Case: correct hash for given input is returned
  # Failure Cases: incorrect hash is returned or error occurs
  
  # hash 'cd15' is returned on input 'aaa'
  # note calculate is stubbed over for test
  def test_create_hash
    hasher = Hasher::new
    def hasher.calculate input; 41152263; end
    input = 'aaa'
    assert_equal('cd15' ,hasher.create_hash(input))
  end
  
end