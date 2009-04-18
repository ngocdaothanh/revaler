if ARGV.length != 2
  puts "Usage: <program name> <host> <port>"
  exit
end

require File.join(File.dirname(__FILE__), '../lib/ruby_eval_server')

host = ARGV[0]
port = ARGV[1].to_i
EventMachine::run { EventMachine::start_server(host, port, RubyEvalServer) }
