require 'rubygems'
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::XML(open("http://api.flickr.com/services/feeds/photos_public.gne?id=58196490@N08&lang=en-us&format=rss_200"))

puts "errors exist" if (doc.errors.any?)

doc.xpath('//item').each do |node|
  puts(node.xpath('title').text)
  puts(node.xpath('media:content').attr('url'))
end
