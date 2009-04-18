require 'rubygems'
require 'eventmachine'

module RubyEvalUtils
  NUM_BYTES_FOR_PAYLOAD_LENGTH = 4

  def send_payload(payload)
    length = payload.length
    bytes = [length].pack('N')
    bytes << payload
    send_data(bytes)
  end

  # Returns [rest, payloads].
  def extract_payloads(buffer, payloads = [])
    return [buffer, payloads] if buffer.length < NUM_BYTES_FOR_PAYLOAD_LENGTH

    playload_length_string = buffer.slice(0, NUM_BYTES_FOR_PAYLOAD_LENGTH)
    playload_length = 0
    NUM_BYTES_FOR_PAYLOAD_LENGTH.times do |i|
      byte = playload_length_string.slice!(0)
      multiplier = 2**(8*(NUM_BYTES_FOR_PAYLOAD_LENGTH - i - 1))
      playload_length += byte*multiplier
    end

    return [buffer, payloads] if buffer.length < NUM_BYTES_FOR_PAYLOAD_LENGTH + playload_length

    payload = buffer.slice(NUM_BYTES_FOR_PAYLOAD_LENGTH, playload_length)
    skipped_length = NUM_BYTES_FOR_PAYLOAD_LENGTH + playload_length
    rest = buffer.slice(skipped_length, buffer.length - skipped_length)
    extract_payloads(rest, payloads << payload)
  end
end
