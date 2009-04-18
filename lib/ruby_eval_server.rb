require File.join(File.dirname(__FILE__), 'ruby_eval_utils')

module RubyEvalServer
  include RubyEvalUtils

  def post_init
    puts 'Client connected'
  end

  def receive_data(bytes)
    @buffer = '' unless @buffer

    @buffer << bytes
    @buffer, payloads = extract_payloads(@buffer)
    payloads.each do |payload|
      result = eval_more(payload) rescue ($!.to_s + "\n" + $!.backtrace.join("\n"))
      send_payload(result.to_s)
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
