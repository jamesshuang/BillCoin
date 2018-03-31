class Parser
  
  # returns array of lines from file
  # exit on empty file
  def parse_file file
    lines = []
    
    file.each_line do |line|
      lines << line.chomp
    end
    
    if lines.count == 0
      puts "Empty file. Please provide valid file."
      exit()
    end
    
    lines
  end
  
  # splits line into individual blockchain components
  # exit if invalid component format
  def parse_line line
    split = line.split('|')
    
    if split.count != 5
      puts "Incorrect blockchain format"
      exit()
    else
      split
    end
  end
  
  # retunrs each line component
  def parse_line_items line
    if line.count != 5
      puts "Incorrect blockchain format"
      exit()
    end
    
    return line[0], line[1], line[2], line[3], line[4]
  end
  
  # returns transaction string split into individual transactions
  def parse_transaction transaction
    transaction.split(':')
  end
  
  # returns individual transaction split into sending and receiving
  def parse_single_transaction transaction
    split = transaction.split('>')
    
    if split.count != 2
      puts "Incorrect blockchain format"
      exit()
    else
      split
    end
  end
  
  # returns receiving user and amount
  # exit if invalid amount value
  def parse_receiving_amount transaction
    if transaction.chars.first == '('
      puts "Incorrect transaction format"
      exit()
    end
    
    transaction_split = transaction.split('(')
    
    if transaction_split.count != 2
      puts "Incorrect transaction format"
      exit()
    end
    
    user = transaction_split.first
    
    amount_to_parse = transaction_split.last
    amount_split = amount_to_parse.split(')')
    
    if amount_split.count != 1
      puts "Incorrect transaction format"
      exit()
    end
    
    amount = Integer(amount_split.first) rescue false
    
    if !amount
      puts "Incorrect transaction format"
      exit()
    end
    
    return user, amount
  end
  
  # returns seconds and nanoseconds as integers
  # exit if invalid second or nanosecond value
  def parse_timestamp timestamp
    timestamp = timestamp.split('.')
    
    if timestamp.count != 2
      puts "Incorrect timestamp format"
      exit()
    end
    
    seconds = Integer(timestamp.first) rescue false
    nanoseconds = Integer(timestamp.last) rescue false
    
    if !seconds || !nanoseconds
      puts "Invalid timestamp format"
      exit()
    end
    
    return seconds, nanoseconds
  end
  
  # checks if file is valid format
  # return true if valid, otherwise false
  def correct_file file_name
    file_name.end_with? '.txt'
  end
  
  def correct_argument_number arg
    if arg.count != 1 
      puts "Incorrect number of arguments."
      puts "Please provide one textfile name as a command line argument."
      exit()
    else
      true
    end
  end
  
end