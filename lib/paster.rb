class PasterError < RuntimeError
  def initialize msg
    super "#{msg} -- consider reporting this issue to GitHub"
  end
end

def Paster paste
  Struct.new :expire do
    @paste = paste

  def services
    [
    [
      10000000, [false],
      "http://sprunge.us", :sprunge,
      nil,
      nil,
      ->_{
        found = File.read("lib/pygments.txt").scan(/pygments.lexers.([a-z_0-9]+)', '([^']+)'/).rassoc @lang
        "#{_.strip}#{"?#{found.first}" if found}"
      },
    ],
    [
      15000000, [false, "burn", 0, 5, 60, 1440, 10080, 40320, 483840],
      "https://paste.the-compiler.org/api/create", :text,
      ((
        found = File.read("lib/genshi.txt").scan(/'([a-z_0-9-]+)' => '([^']+)',/).rassoc @lang
        found.first if found
      )),
      expire,
      ->_{
        next _ unless expire == "burn"
        require "oga"
        Oga.parse_html(_).css("input").tap do |_|
          raise PasterError.new "can't parse response from paste.the-compiler.org" unless 1 == _.size
        end.first["value"]
      }
    ],
    ].reject do |max_size, possible_expiration, |
      next true if self.class.instance_variable_get(:@paste).size > max_size
      next true unless possible_expiration.include? expire
    end
  end

  def initialize
    STDOUT.sync = true
    require "linguist"
    @lang = Linguist.detect(Linguist::Blob.new "", self.class.instance_variable_get(:@paste))&.name
  end

  def paste
  services.map do |_, _, url, field, lang = nil, expire = nil, callback = ->_{_}|
    Thread.new do
      require "nethttputils"
      puts callback.call NetHTTPUtils.request_data url, :post,
        form: {field => self.class.instance_variable_get(:@paste), :lang => lang, :expire => expire}.select{ |k, v| v }
    end
  end.each &:join
  end

  end.new
end
