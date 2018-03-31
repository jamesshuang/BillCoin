require 'minitest/autorun'
require_relative 'billcoin'

# unit tests for billcoin.rb 

class BillCoinTest < Minitest::Test

  # UNIT TESTS FOR METHOD add_user user
  # Equivalence classes:
  # A new username is passed => user is added to user_totals
  # An existing username is passed => no action
  # SYSTEM is passed => no action (SYSTEM does not have a balance)
  
  # new user is added to user_totals
  def test_add_new_user
    billcoin = BillCoin::new
    user = 'NewUser'
    billcoin.add_user user
    assert_includes billcoin.user_totals.keys, user
  end
  
  # no action taken when attempting to add user that already exists
  def test_add_existing_user
    billcoin = BillCoin::new
    user = 'NewUser'
    billcoin.user_totals['NewUser'] = 0
    billcoin.add_user user
    assert_includes billcoin.user_totals.keys, user
    assert_equal 1, billcoin.user_totals.count
  end
  
  # no action taken when attempting to add SYSTEM
  def test_add_system
    billcoin = BillCoin::new
    user = 'SYSTEM'
    billcoin.add_user user
    refute_includes billcoin.user_totals.keys, user
  end
  
  # UNIT TESTS FOR METHOD verify_valid_timestamp previous, current, line_number, parser
  # Equivalence classes:
  # current timestamp is after previous timestamp => false returned
  # current timestamp is before previous timestamp => system exits
  # current timestamp is equal to previous timestamp => system exits
  
  # current > previous, false returned
  def test_valid_timestamp
    billcoin = BillCoin::new
    parser = Minitest::Mock.new('Parser')
    def parser.parse_timestamp timestamp
      timestamp.split('.').map! {|x| Integer(x)}
    end
    refute billcoin.verify_valid_timestamp('1518893687.562508000', '1518893687.562508100', 0, parser)
  end
  
  # current < previous, system exit
  def test_earlier_timestamp
    billcoin = BillCoin::new
    parser = Minitest::Mock.new('Parser')
    def parser.parse_timestamp timestamp
      timestamp.split('.').map! {|x| Integer(x)}
    end
    assert_raises SystemExit do
      billcoin.verify_valid_timestamp('1518893688.562508000', '1518893687.562508100', 0, parser)
    end
  end
  
  # current == previous, system exit
  def test_equal_timestamp
    billcoin = BillCoin::new
    parser = Minitest::Mock.new('Parser')
    def parser.parse_timestamp timestamp
      timestamp.split('.').map! {|x| Integer(x)}
    end
    assert_raises SystemExit do
      billcoin.verify_valid_timestamp('1518893688.562508000', '1518893688.562508000', 0, parser)
    end
  end
  
  
end