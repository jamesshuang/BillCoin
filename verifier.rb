require_relative 'billcoin'
require_relative 'hasher'
require_relative 'parser'

require 'flamegraph'

begin
  Flamegraph.generate('verifier.html') do
    billcoin = BillCoin::new
    hasher = Hasher::new
    parser = Parser::new
    parser.correct_argument_number ARGV

    filename = ARGV[0]
    billcoin.verify hasher, parser, filename
  end
rescue
  puts "INVALID BLOCKCHAIN"
  exit()
end