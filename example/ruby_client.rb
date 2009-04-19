if ARGV.length != 2
  puts "Usage: <program name> <host> <port>"
  exit
end

require File.join(File.dirname(__FILE__), '../lib/revaler_utils')

class RubyClient < EM::Connection
  include RevalerUtils

  def post_init
    puts 'Connected to server'
    puts 'Type in command to be executed, empty to exit'
    Thread.new do
      while !(payload = $stdin.gets.chop).empty?
        self.send_payload(payload)
      end

      self.close_connection(false)
      EM.stop
    end
  end

  def receive_data(bytes)
    @buffer = '' unless @buffer

    @buffer << bytes
    @buffer, payloads = extract_payloads(@buffer)
    payloads.each do |payload|
      puts payload
    end
  end

  def unbind
    EM.stop
  end
end

host = ARGV[0]
port = ARGV[1].to_i
EM::run do
  $client = EM::connect(host, port, RubyClient)
end
