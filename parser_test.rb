require 'minitest/autorun'
require_relative 'parser'

# unit testing for parser.rb

class ParserTest < Minitest::Test

  # UNIT TESTS FOR METHOD parse_receiving_amount transaction
  # Success Cases: Input is in format: user(amount)
  # Failure Cases: Different format is given

  # receiving input is in valid format, [user, amount] is returned
  def test_receiving_amount_valid
    parser = Parser::new
    transaction = "Cyrus(10)"
    assert_equal(["Cyrus", 10], parser.parse_receiving_amount(transaction)) 
  end
  
  # receiving input is invalid format, program exits
  def test_receiving_amount_invalid_format
    parser = Parser::new
    transaction = "Cyrus[10]"
    assert_raises SystemExit do
      parser.parse_receiving_amount transaction
    end
  end
  
  # receiving input is missing a component, program exits
  def test_receiving_amount_no_name
    parser = Parser::new
    transaction = "(10)"
    assert_raises SystemExit do
      parser.parse_receiving_amount transaction
    end
  end
  
  # UNIT TESTS FOR METHOD parse_timestamp timestamp
  # Success Cases: Input is in format seconds.nanoseconds where seconds and nanoseconds are integers
  # Failure Cases: Different format is given or values are not integers
  
  # timestamp input is in valid format, [seconds, nanoseconds] is returned
  def test_timestamp_valid
    parser = Parser::new
    timestamp = "1518893687.562508000"
    assert_equal([1518893687, 562508000], parser.parse_timestamp(timestamp))
  end
  
  # timestamp input is invalid format, program exits
  def test_timestamp_invalid_format
    parser = Parser::new
    timestamp = "15188.93687-562508000"
    assert_raises SystemExit do
      parser.parse_timestamp timestamp
    end
  end
  
  # timestamp input not integers, program exits
  def test_timestamp_invalid_types
    parser = Parser::new
    timestamp = "1518893687.twenty"
    assert_raises SystemExit do
      parser.parse_timestamp timestamp
    end
  end
  
end