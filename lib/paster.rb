def Paster paste
  STDOUT.sync = true
  puts "paste size: #{paste.size}"

  require "linguist"
  lang = Linguist.detect(Linguist::Blob.new "", paste).name
  [
    [
      "http://sprunge.us", :sprunge,
      nil,
      ->_{
        found = File.read("lib/pygments.txt").scan(/pygments.lexers.([a-z_0-9]+)', '([^']+)'/).rassoc lang
        "#{_.strip}#{"?#{found.first}" if found}"
      },
    ],
    [
      "https://paste.the-compiler.org/api/create", :text,
      ((
        found = File.read("lib/genshi.txt").scan(/'([a-z_0-9-]+)' => '([^']+)',/).rassoc lang
        found.first if found
      )),
    ],
  ].map do |url, field, lang = nil, callback = ->_{_}|
    Thread.new do
      require "nethttputils"
      puts callback.call NetHTTPUtils.request_data url, :post, form: (lang ? {field => paste, :lang => lang} : {field => paste})
    end
  end.each &:join
end
