class BillCoin
  
  attr_accessor :user_totals
  
  def initialize
    @user_totals = Hash::new # dictionary {user_name, user_total}
  end
  
  # returns new file object for a given transaction file
  # exit if file is not valid
  def open_file parser, filename
    if !File.exist?(filename)
      puts "#{filename} does not exist. Please provide a valid file."
      exit()
    elsif !parser.correct_file filename
      puts "Please provide a .txt file as an argument."
      exit()
    end
    
    file = File.open(filename, "r")
  end
  
  # verify/calculate lines in file
  def verify hasher, parser, filename
    file = open_file parser, filename
    lines = parser.parse_file file
    
    expected_block_number = 0
    line_number = 0
    expected_hash = "0"
    previous_time = "0.0"
    # verify each line/transaction
    for line in lines do
      # parse line into components
      line = parser.parse_line line
      block_number, actual_hash, transaction_string, timestamp_string, current_hash = parser.parse_line_items line
      # verify timestamp
      verify_valid_timestamp previous_time, timestamp_string, line_number, parser
      # verify previous read and calculated hashes
      to_be_hashed = "#{block_number}|#{actual_hash}|#{transaction_string}|#{timestamp_string}"
      verify_previous_hash expected_hash, actual_hash, line_number
      # update previous calculated hash to this current hash
      expected_hash = hasher.create_hash to_be_hashed
      # execute transactions
      evaluate_all_transactions parser, transaction_string
      # make sure no users have negative totals
      verify_nonnongetative_totals @user_totals, line_number
      # make sure block_number is previous + 1
      verify_correct_block_number expected_block_number, block_number, line_number
      # make sure that read and newly calculated hashes match
      verify_correct_hash expected_hash, current_hash, line_number, to_be_hashed
      # update values
      expected_block_number += 1 
      line_number += 1
      previous_time = timestamp_string
    end
    
    print_user_totals @user_totals
  end
  
  # output user totals
  def print_user_totals dict
    dict.each do |key, value|
      puts "#{key}: #{value}"
    end
  end
  
  # evaluate all transactions in transaction string
  def evaluate_all_transactions parser, transaction_string
    all_transactions = parser.parse_transaction transaction_string
    for transaction in all_transactions do
      evaluate_single_transaction transaction, parser
    end
  end
  
  # execute a transaction
  # add/subtract user balances
  def evaluate_single_transaction transaction, parser
    transaction_info = parser.parse_single_transaction transaction
    
    sending_user = transaction_info.first
    receiving_user, amount = parser.parse_receiving_amount transaction_info.last
    
    add_user sending_user
    add_user receiving_user
    
    if sending_user != "SYSTEM"
      @user_totals[sending_user] = @user_totals[sending_user] - amount
    end
    
    if receiving_user != "SYSTEM"
      @user_totals[receiving_user] = @user_totals[receiving_user] + amount
    end
  end
  
  # add new user if they don't already exist in @user_totals
  def add_user user
    if (!@user_totals.has_key? user) && (user != "SYSTEM")
      @user_totals[user] = 0
    end
  end
  
  # verify that no users have negative balances
  # exit if user has negative balance
  def verify_nonnongetative_totals dict, line_number
    dict.each do |key, value|
      if value < 0
        puts "Line #{line_number}: Invalid block, address #{key} has #{value} billcoins!"
        puts "BLOCKCHAIN INVALID"
        exit()
      end
    end
  end
  
  # verify that block numbers are valid
  # exit if invalid block number order (not the previous number + 1)
  def verify_correct_block_number expected, actual, line_number
    actual = Integer(actual) rescue false
    
    if !actual 
      puts "Line #{line_number}: Invalid block number format, should be #{expected}"
      puts "BLOCKCHAIN INVALID"
      exit()
    end
    
    if expected != actual
      puts "Line #{line_number}: Invalid block number #{actual}, should be #{expected}"
      puts "BLOCKCHAIN INVALID"
      exit()
    end
  end
  
  # verify previous hash value is correct
  # exit if hashes do not match and it is not the first line
  def verify_previous_hash previous, current, line_number
    if previous != current && previous != '0'
      puts "Line #{line_number}: Previous hash was #{current}, should be #{previous}"
      puts "BLOCKCHAIN INVALID"
      exit()
    end
  end
  
  # verify that hashes are equal
  # exit if expected and actual hashes don't match
  def verify_correct_hash expected, actual, line_number, pre_hash
    if expected != actual
      puts "Line #{line_number}: String '#{pre_hash}' hash set to #{actual}, should be #{expected}"
      puts "BLOCKCHAIN INVALID"
      exit()
    end
  end
  
  # verify current timestamp is after previous timestamp
  # exit if invalid timestamp (back in time)
  def verify_valid_timestamp previous, current, line_number, parser
    previous_seconds, previous_nanoseconds = parser.parse_timestamp previous
    current_seconds, current_nanoseconds = parser.parse_timestamp current
    
    invalid_timestamp = false
    if previous_seconds > current_seconds
      invalid_timestamp = true
    elsif previous_seconds == current_seconds
      if previous_nanoseconds >= current_nanoseconds
        invalid_timestamp = true
      end
    end
    
    if invalid_timestamp
      puts "Line #{line_number}: Previous timestamp #{previous} >= new timestamp #{current}"
      puts "BLOCKCHAIN INVALID"
      exit()
    end
    
    invalid_timestamp
  end
end