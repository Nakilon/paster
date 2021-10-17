require "nethttputils"
NetHTTPUtils.logger.level = ENV.fetch("LOGLEVEL_Paster", "fatal").to_sym

def Paster paste
  Struct.new :lang, :expire, :unlist do
    @paste = paste
    # TODO: write the reasons why we use Struct and differ its attrs from the instance variables
    # one of them is that we don't want to see @paste in .inspect (but that's not the only way to do it though)

    def initialize
      STDOUT.sync = true
      require "linguist"
      self.lang = Linguist.detect(Linguist::Blob.new "", self.class.instance_variable_get(:@paste))&.name
    end

    def services
      assert_one = lambda do |_, resp|
        next if 1 == _.size
        require "tmpdir"
        filename = File.join Dir.tmpdir, "paster.htm"
        File.write filename, resp
        raise RuntimeError.new "can't parse response (stored response to #{filename})"
      end
      [
        [
          10000000, [0], nil,
          expire[0], false,
          "http://sprunge.us", "sprunge", nil,
          nil,
          ->resp{
            found = File.read("lib/pygments.txt").scan(/pygments.lexers.([a-z_0-9]+)', '([^']+)'/).rassoc lang
            [
               "raw:       #{resp}",
              ("formatted: #{resp.chomp}?#{found.first}" if found),
            ].compact
          },
        ],
        [
          15000000, ["burn", 0, 5, 60, 1440, 10080, 40320, 483840], nil,
          expire[0], true,
          "https://paste.the-compiler.org/api/create", "text", nil,
          File.read("lib/genshi.txt").scan(/'([a-z_0-9-]+)' => '([^']+)',/).rassoc(lang)&.first,
          ->resp{
            s = expire[0] == "burn" ? ((
              require "oga"
              Oga.parse_html(resp).css("input").tap do |_|
                assert_one.call _, resp
              end.first["value"]
            )) : resp
            [
              "formatted: #{s}",
              "raw:       #{s.sub(/(.+)\//, "\\1/raw/")}",
            ]
          }
        ],
        [
          150000, [-1, 3600, 86400, 259200, 7776000], ->_{ 2 > _.count("\n") },
          expire[1], true,
          "https://paste.debian.net", "code", :multipart,
          File.read("lib/pygments.txt").scan(/([^']+)', \(([^)]*)/).map{ |_, __| [_, __[/(?<=')[^']*/]] }.assoc(lang)&.last || "-1",
          ->resp{
            url = resp.instance_variable_get(:@last_response).uri.to_s.chomp("/")
            require "oga"
            [
              "formatted: #{url}",
              "raw:       #{url.sub(/(.+)\//, "\\1/plain/")}",
              "delete:    #{
                URI.join "https://paste.debian.net", Oga.parse_html(resp).css("a").map{ |a| a["href"] }.grep(/delete/).tap{ |_|
                  assert_one.call _, resp
                }.first
              }",
            ]
          },
          false,
          {"paste"=>"Send"},
        ],
      ].reject do |max_size, possible_expiration, callback, expire, |
        next true if self.class.instance_variable_get(:@paste).size > max_size
        next true unless possible_expiration.include? expire
        next true if (callback || ->_{}).call self.class.instance_variable_get(:@paste)
      end
    end

    def paste
      services.map do |_, _, _, expire, unlistable, url, field, multipart, lang, callback, no_redirect = true, extra = {}|
        Thread.new do
          puts begin
            callback.call NetHTTPUtils.request_data url, :post, *multipart, no_redirect: no_redirect,
              form: {lang: lang, expire: expire}.merge({private: (1 if unlistable && unlist)}).map{ |k, v| [k.to_s, v.to_s] if v }.compact.to_h.merge(extra).merge({field => self.class.instance_variable_get(:@paste)})
            # if we .strip the response before sending to callback it won't have the last_response instance_variable that we need for some services
          rescue => e
            "failed to paste to #{url}: #{e} -- consider reporting this issue to GitHub"
          end
        end
      end.each &:join
    end

  end.new
end
