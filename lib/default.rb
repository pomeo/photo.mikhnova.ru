# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require 'nokogiri'
require 'open-uri'
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'
require 'russian'
require 'unicode'
require 'RMagick'
include Magick

$KCODE = 'u'

def img_r(id)
  image = Magick::Image.read("tmp/#{id}.jpg").first
  if (image.columns > image.rows)
    image1 = image.resize_to_fit(584, nil)
    image2 = image.resize_to_fill(150, 150)
  else
    image1 = image.resize_to_fit(nil, 584)
    image2 = image.resize_to_fill(150, 150)
  end
  f1 = File.new("content/images/#{id}.jpg", "wb")
  f1.write image1.to_blob
  f1.close
  
  f2 = File.new("content/images/#{id}-thumb.jpg", "wb")
  f2.write image2.to_blob
  f2.close
end

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/imgs.db")

class ImageFlickr
  include DataMapper::Resource
  storage_names[:default] = "images"

  property :id,                Serial
  property :name,              String
  property :url,               String
  property :remove,            Integer

  after :save do |img|
    ig = "tmp/#{img.id}.jpg"
    open(ig, 'wb') do |file|
      file << open(img.url).read
    end
    img_r(img.id)
  end
end

# DataMapper.auto_migrate!

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
  if !ImageFlickr.first(:url => a[i-1])
    @imgc = ImageFlickr.create(
                               :name      => a[i-2],
                               :url       => a[i-1],
                               :remove    => 0
                               )
  end
  i -= 2
end while i > 0

$n = 0
$m = 0
$p = 1
$c = (ImageFlickr.count(:remove => 0))-1
$a = $c
$r = ImageFlickr.all(:remove => 0)
$r = $r.to_a
