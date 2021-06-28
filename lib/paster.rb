require "nethttputils"
NetHTTPUtils.logger.level = ENV.fetch("LOGLEVEL_Paster", "fatal").to_sym
NetHTTPUtils.class_variable_get(:@@_405).add "sprunge.us"
NetHTTPUtils.class_variable_get(:@@_405).add "paste.the-compiler.org"
NetHTTPUtils.class_variable_get(:@@_405).add "paste.debian.net"

def Paster paste
  Struct.new :expire do
    @paste = paste

    def initialize
      STDOUT.sync = true
      require "linguist"
      @lang = Linguist.detect(Linguist::Blob.new "", self.class.instance_variable_get(:@paste))&.name
    end

    def services
      [
        [
          10000000, [nil], nil,
          expire[0],
          "http://sprunge.us", "sprunge", nil,
          nil,
          nil,
          ->_{
            found = File.read("lib/pygments.txt").scan(/pygments.lexers.([a-z_0-9]+)', '([^']+)'/).rassoc @lang
            "#{_.strip}#{"?#{found.first}" if found}"
          },
        ],
        [
          15000000, [nil, "burn", 0, 5, 60, 1440, 10080, 40320, 483840], nil,
          expire[0],
          "https://paste.the-compiler.org/api/create", "text", nil,
          File.read("lib/genshi.txt").scan(/'([a-z_0-9-]+)' => '([^']+)',/).rassoc(@lang)&.first,
          nil,
          ->_{
            next _ unless expire[0] == "burn"
            require "oga"
            Oga.parse_html(_).css("input").tap do |_|
              raise RuntimeError.new "can't parse response" unless 1 == _.size
            end.first["value"]
          }
        ],
        [
          150000, [nil, -1, 3600, 86400, 259200, 7776000], ->_{ 2 > _.count("\n") },
          expire[1],
          "https://paste.debian.net", "code", :multipart,
          File.read("lib/pygments.txt").scan(/([^']+)', \(([^)]*)/).map{ |_, __| [_, __[/(?<=')[^']*/]] }.assoc(@lang)&.last || "-1",
          {"paste"=>"Send"},
          ->_{
            require "oga"
            URI.join("https://paste.debian.net", Oga.parse_html(_).css("a").tap{ |_|
              raise RuntimeError.new "can't parse response" unless 1 == _.size
            }.first["href"]).to_s
          }
        ],
      ].reject do |max_size, possible_expiration, callback, expire, |
        next true if self.class.instance_variable_get(:@paste).size > max_size
        next true unless possible_expiration.include? expire
        next true if (callback || ->_{}).call self.class.instance_variable_get(:@paste)
      end
    end

    def paste
      services.map do |_, _, _, expire, url, field, multipart, lang, extra, callback = ->_{_}|
        Thread.new do
          puts begin
            callback.call NetHTTPUtils.request_data url, :post, *multipart, no_redirect: true,
              form: {"lang" => lang, "expire" => expire}.map{ |k, v| [k, v.to_s] if v }.compact.to_h.merge(extra || {}).merge({field => self.class.instance_variable_get(:@paste)})
          rescue => e
            "failed to paste to #{url}: #{e} -- consider reporting this issue to GitHub"
          end
        end
      end.each &:join
    end

  end.new
end
