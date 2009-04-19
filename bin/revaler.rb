if ARGV.length != 2
  puts "Usage: <program name> <host> <port>"
  exit
end

require File.join(File.dirname(__FILE__), '../lib/revaler')

trap(:INT) { EM.stop }

host = ARGV[0]
port = ARGV[1].to_i
EM::run { EM::start_server(host, port, Revaler) }
