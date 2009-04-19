require File.join(File.dirname(__FILE__), 'revaler_utils')

module Revaler
  include RevalerUtils

  def post_init
    puts 'Client connected'
  end

  def receive_data(bytes)
    @buffer = '' unless @buffer

    @buffer << bytes
    @buffer, payloads = extract_payloads(@buffer)
    payloads.each do |payload|
      result = eval_more(payload).to_s rescue ($!.to_s + "\n" + $!.backtrace.join("\n"))
      puts "#{payload}  # => #{result}"
      send_payload(result)
    end
  end

  def unbind
    puts 'Client disconnected'
  end

  private

  # Evaluates payload and returns the result.
  def eval_more(payload)
    # @result and @binding are used as static variable in C
    @result = nil
    @binding = binding if @binding.nil?
    cmd = "@result = (#{payload}); binding"
    @binding = eval(cmd, @binding)
    @result
  end
end
