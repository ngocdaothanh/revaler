require 'rubygems'
require 'eventmachine'

module RubyEvalServer
  def self.start(host, port)
    EventMachine::run { EventMachine::start_server(host, port, self) }
  end

  def post_init
    @ruby_eval_server_binding = nil
    @ruby_eval_server_result  = nil
    @ruby_eval_server_command_length = nil
    @ruby_eval_server_command_string = nil
  end

  def receive_data(bytes)
    send_data ">>>you sent: #{data}"
    close_connection if data =~ /quit/i
  end

  def eval2(cmd)
    unless $binding
    $binding = binding
    p 9
  end
    $binding = eval("$result = (" + cmd + "); binding", $binding)
    $result
  end
end
