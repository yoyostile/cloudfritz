# frozen_string_literal: true

# Use it like this:
# https://cloudfritz.r4r3.me/update?key=<pass>&email=<username>&zone=YOURZONE&domain=<domain>&ip=<ipaddr>&ipv6=<ip6addr>

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

TYPE_MAPPING = { A: :ip, AAAA: :ipv6 }.freeze

module Cloudflare
  class DNSRecords < Resource
    def find_by_params(params)
      response = get(params: params)

      return if response.empty?

      record = response.results.first

      DNSRecord.new(concat_urls(url, record[:id]), record, **options)
    end
  end
end

get '/update' do
  connection = Cloudflare.connect(key: params[:key], email: params[:email])
  zone = connection.zones.find_by_name(params[:zone])

  TYPE_MAPPING.each_key do |type|
    record = zone.dns_records.find_by_params(name: params[:domain], type: type)
    value = params[TYPE_MAPPING[type]]
    if record && value
      record.update_content(value)
    elsif value
      name = params[:domain].gsub(/.#{params[:zone]}/, '')
      zone.dns_records.post({
        type: type,
        name: name,
        content: value,
        proxied: false
      }.to_json, content_type: 'application/json')
    end
  end
  'Ok.'
end

get '/healthz' do
  'Running.'
end
