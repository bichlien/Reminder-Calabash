#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'json'

url = URI("https://hooks.slack.com/services/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")
http = Net::HTTP.new(url.host, url.port)

http.use_ssl = true
# http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(url)
request["content-type"] = 'application/json'

file = File.read('cucumber.json')
data_hash = JSON.parse(file)

jsonData = []


# {
#   title: "Required Field Title", # The title may not contain markup and will be escaped for you
#   value: "Text value of the field. \nMay contain standard message markup and must be escaped as normal. May be multi-line.",
#   short: false # Optional flag indicating whether the `value` is short enough to be displayed side-by-side with other values
# }

data_hash.each do |feature|
  tempFeature = {
    title: feature['name'],
    color: "good"
  }

  scenarioFields = []

  feature['elements'].each do |scenario|
    scenarioStep = ''
    scenarioField = {
      title: scenario['name'],
      color: 'good',
      mrkdwn: 'true'
    }

    scenario['steps'].each do |step|
      scenarioStep += '\n' + step['name'] + " - *" + step['result']['status'].upcase + "*"
    end

    scenarioField['value'] = scenarioStep

    scenarioFields.push(scenarioField)
  end

  tempFeature['fields'] = scenarioFields
  jsonData.push(tempFeature)
end

request.body = {
  attachments: jsonData
}.to_json.gsub! '\\\\', '\\'

response = http.request(request)
