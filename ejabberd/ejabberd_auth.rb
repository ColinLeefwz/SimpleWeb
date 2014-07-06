#!/usr/bin/env ruby

require 'logger'
#require 'rest_client'

$stdout.sync = true
$stdin.sync = true

path = "/Users/ylt/lianlian/auth.log"
file = File.open(path, File::WRONLY | File::APPEND | File::CREAT)
file.sync = true
logger = Logger.new(file)
logger.level = Logger::DEBUG

def auth(username, password)
  #RestClient.post("http://my-rails-app.com/login", :username => username, :password => password)
  return password=="pass"
  #rescue RestClient::Exception
  #return false
end

logger.info "Starting ejabberd authentication service"

loop do
  begin
    $stdin.eof? # wait for input
    start = Time.now

    msg = $stdin.read(2)
    next if msg.nil?
    length = msg.unpack('n').first

    msg = $stdin.read(length)
    cmd, *data = msg.split(":")

    logger.info "Incoming Request: '#{cmd}'"
    success = case cmd
    when "auth"
      logger.info "Authenticating #{data[0]}@#{data[1]}"
      auth(data[0], data[2])
    else
      true
    end

    bool = success ? 1 : 0
    $stdout.write [2, bool].pack("nn")
    logger.info "Response: #{success ? "success" : "failure"}"
  rescue => e
    logger.error "#{e.class.name}: #{e.message}"
    logger.error e.backtrace.join("\n\t")
  end
end

