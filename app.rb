# frozen_string_literal: true

# Use it like this:
# https://cloudfritz.r4r3.me/update?key=<pass>&email=<username>&zone=YOURZONE&domain=<domain>&ip=<ipaddr>

require 'sinatra'
require 'cloudflare'

disable :logging

logger = Logger.new(STDERR)
logger.instance_eval do
  def write(msg)
    msg = msg.gsub(/(email|key)=(.*?)&/, '\1=<REDACTED>&')
    send(:<<, msg)
  end
end

use Rack::CommonLogger, logger

get '/update' do
  connection = Cloudflare.connect(key: params[:key], email: params[:email])
  zone = connection.zones.find_by_name(params[:zone])
  record = zone.dns_records.find_by_name(params[:domain])
  record.update_content(params[:ip])
end
