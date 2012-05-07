require 'stringio'
require 'zlib'

class OutputCompressionFilter

  # Do output compression if the client supports it
  def self.filter(controller)
    return if controller.request.env['HTTP_ACCEPT_ENCODING'].nil?
    if controller.request.env['HTTP_ACCEPT_ENCODING'].match(/gzip/)
      if controller.response.headers["Content-Transfer-Encoding"] != 'binary'
        begin
          controller.logger.info "Compressing"
          ostream = StringIO.new
          gz = Zlib::GzipWriter.new(ostream)
          gz.write(controller.response.body)
          controller.response.body = ostream.string
          controller.response.headers['Content-Encoding'] = 'gzip'
        ensure
          gz.close if gz
        end
      end
    end
  end

end