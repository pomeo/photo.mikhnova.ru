require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'dm-core'
require 'dm-migrations'
require 'russian'
require 'unicode'

$KCODE = 'u'

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, "sqlite3:///var/www/mikhnova.ru/photo/db/imgs.db")

class Image
  include DataMapper::Resource
  # storage_names[:default] = "image"

  property :id,                Serial
  property :name,              String
  property :url,               String
  property :remove,            Integer

  after :save do |img|
    puts("#{img.id}-!!!!!!!!")
    ig = "tmp/#{img.id}.jpg"
    open(ig, 'wb') do |file|
      file << open(img.url).read
    end
    
  end
end

DataMapper.auto_migrate!

doc = Nokogiri::XML(open("http://api.flickr.com/services/feeds/photos_public.gne?id=58196490@N08&lang=en-us&format=rss_200"))

puts "errors exist" if (doc.errors.any?)

i = 0
a = Array.new

doc.xpath('//item').each do |node|
  a[i] = node.xpath('title').text
  a[i+1] = node.xpath('media:content').attr('url')
  i += 2
end

begin
  @img = Image.create(
                      :name      => a[i-2],
                      :url       => a[i-1],
                      :remove    => 0
                      )
  i -= 2
end while i > 0

# $image = Image.all(:order => [ :id.desc ], :remove => 0 )

# puts(a.reverse)
