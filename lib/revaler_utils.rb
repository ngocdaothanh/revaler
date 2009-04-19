require 'rubygems'
require 'eventmachine'

module RevalerUtils
  HEADER_NUM_BYTES = 4

  def send_payload(payload)
    length = payload.length
    header = [length].pack('N')
    send_data(header + payload)
  end

  # Returns [rest, payloads].
  def extract_payloads(buffer, payloads = [])
    return [buffer, payloads] if buffer.length < HEADER_NUM_BYTES

    header = buffer.slice(0, HEADER_NUM_BYTES)
    playload_length = 0
    header.unpack("C#{HEADER_NUM_BYTES}").each_with_index do |byte, i|
      multiplier = 2**(8*(HEADER_NUM_BYTES - i - 1))
      playload_length += byte*multiplier
    end

    return [buffer, payloads] if buffer.length < HEADER_NUM_BYTES + playload_length

    payload = buffer.slice(HEADER_NUM_BYTES, playload_length)
    skipped_length = HEADER_NUM_BYTES + playload_length
    rest = buffer.slice(skipped_length, buffer.length - skipped_length)
    extract_payloads(rest, payloads << payload)
  end
end
