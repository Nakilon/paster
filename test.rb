require "minitest/autorun"

describe :prompt do
  begin
    require "tempfile"
    tempfile = Tempfile.new "secure_shell.zip"
    require "open-uri"
    File.binwrite tempfile, (Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5") ? Kernel : URI).open("http://md5.nakilon.pro/0f83810b3b3fb1978db3803dee52ac5e", &:read)
    require "zip"
    Zip::File.open tempfile do |zipfile|
      zipfile.each do |entry|
        "iodihamcpbpeioajjeobimgagajmlibd/#{File.dirname entry.name}".tap do |dir|
          FileUtils.mkdir_p dir
          zipfile.extract entry, "iodihamcpbpeioajjeobimgagajmlibd/#{entry.name}"
        end
      end
    end
  ensure
    tempfile.close
    tempfile.unlink
  end unless File.exist? "iodihamcpbpeioajjeobimgagajmlibd"
  require "ferrum"
  br = Ferrum::Browser.new headless: false, browser_options: {
    "disable-extensions-except" => "#{File.expand_path __dir__}/iodihamcpbpeioajjeobimgagajmlibd/0.43_0",
    "load-extension"            => "#{File.expand_path __dir__}/iodihamcpbpeioajjeobimgagajmlibd/0.43_0",
  }
    br.go_to "chrome://extensions/?id=iodihamcpbpeioajjeobimgagajmlibd"
    br.evaluate("document.getElementsByTagName('extensions-manager')[0].shadowRoot.querySelector('extensions-detail-view').shadowRoot.querySelector('#allow-incognito').shadowRoot.querySelector('[role=button]')").click
    sleep 1
    wait_to_find_xpath = lambda do |selector, timeout: 2, &block|
      Timeout.timeout(timeout) do
        sleep 0.1 until found = (block ? block.call : br).at_xpath(selector)
        found
      end
    end

  before do
    br.go_to "chrome-extension://iodihamcpbpeioajjeobimgagajmlibd/html/nassh.html#nakilon@localhost"
    wait_to_find_xpath.call("//*[*[contains(text(),'fingerprint')]]//input"){ br.frames.last }.type("yes\n")
    br.execute "window.removeEventListener('beforeunload', nassh_.onBeforeUnload_)"
    wait_to_find_xpath.call("//*[*[contains(text(),'Password')]]//input"){ br.frames.last }.type("#{File.read "password"}\n")
  end
  it "^C" do
    br.keyboard.type "cd #{Shellwords.escape File.expand_path __dir__}\n"

    get_current_lines = ->{ br.evaluate("term_.getRowsText(0, term_.getRowCount())").split("\n") }
    get_new_lines = lambda do |&block|
      lines1 = get_current_lines.call
      block.call
      lines2 = get_current_lines.call
      lines2.zip(lines1).drop_while{ |a,b| a==b }.map(&:first)
    end

    Timeout.timeout 1 do
      sleep 0.1 until "naki:paster nakilon$ " == get_current_lines.call.last
    end
    assert_equal [
      "",
      "paste size: 65",
      "preview: \"gemspec\\n\\ngem \\\"rubyzip\\...\"",
      "detected language: unknown",
      "",
      "change current options if needed: (Press ↑/↓ arrow to move, Enter to select and letters to filter)",
      "  expiration: virtually forever",
      "  visibility: unlisted",
      "‣ proceed"
    ], (
      get_new_lines.call do
        br.keyboard.type "bundle exec ./bin/paster Gemfile\n"
        Timeout.timeout 2 do
          frames = []
          until frames.last(10).size == 10 && frames.last(10).uniq.size == 1
            sleep 0.1
            frames.push get_current_lines.call
          end
        end
      end.drop 1
    )

    assert_equal \
      ["", "(interrupted by SIGINT)", "naki:paster nakilon$ "],
      get_new_lines.call{ br.keyboard.type :ctrl, ?c; sleep 0.1 }
  end
end

