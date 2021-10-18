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

  get_current_lines = ->{ br.evaluate("term_.getRowsText(0, term_.getRowCount())").split("\n") }
  get_new_lines = lambda do |&block|
    lines1 = get_current_lines.call
    block.call
    lines2 = get_current_lines.call
    lines2.zip(lines1).drop_while{ |a,b| a==b }.map(&:first)
  end
  wait_for_still_frame = lambda do |wait_time = 2, freeze_time = 1|
    Timeout.timeout wait_time do
      frames = []
      until frames.last(freeze_time * 10).size == freeze_time * 10 && frames.last(freeze_time * 10).uniq.size == 1
        sleep 0.1
        frames.push get_current_lines.call
      end
    end
  end

  prompt = "naki:paster nakilon$ "

  before do
    wait_to_find_xpath = lambda do |selector, timeout: 2, &block|
      Timeout.timeout(timeout) do
        sleep 0.1 until found = (block ? block.call : br).at_xpath(selector)
        found
      end
    end
    br.go_to "chrome-extension://iodihamcpbpeioajjeobimgagajmlibd/html/nassh.html#nakilon@localhost"
    wait_to_find_xpath.call("//*[*[contains(text(),'fingerprint')]]//input"){ br.frames.last }.type("yes\n")
    br.execute "window.removeEventListener('beforeunload', nassh_.onBeforeUnload_)"
    wait_to_find_xpath.call("//*[*[contains(text(),'Password')]]//input"){ br.frames.last }.type("#{File.read "password"}\n")

    br.keyboard.type "cd #{Shellwords.escape File.expand_path __dir__}\n"

    Timeout.timeout 2 do
      sleep 0.1 until prompt == get_current_lines.call.last
    end
    assert_equal [
      "",
      "paste size: 108",
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
        wait_for_still_frame.call 3, 1.5
      end.drop 1
    )
  end
  after do
    br.screenshot path: "#{name}.png" unless passed? || skipped?
  end

  it "^C" do
    assert_equal \
      ["", "(interrupted by SIGINT)", prompt],
      get_new_lines.call{ br.keyboard.type :ctrl, ?c; wait_for_still_frame.call }
  end

  it "Enter" do
    lines = get_new_lines.call{ br.keyboard.type :enter; wait_for_still_frame.call 4, 2 }
    assert_equal ["change current options if needed: proceed"], lines.first(1)
    assert_equal ["", prompt], lines.last(2)
    require "nakischema"
    Nakischema.validate lines[1..-3].sort, [[
      /\Adelete:    https:\/\/paste\.debian\.net\/delete\/[a-z0-9]{40}\z/,
      /\Aformatted: https:\/\/paste\.debian\.net\/hidden\/[a-z0-9]{8}\z/,
      /\Aformatted: https:\/\/paste\.the-compiler\.org\/view\/[a-z0-9]{8}\z/,
      /\Araw:       http:\/\/sprunge\.us\/[a-zA-Z0-9]{6}\z/,
      /\Araw:       https:\/\/paste\.debian\.net\/hidden\/plain\/[a-z0-9]{8}\z/,
      /\Araw:       https:\/\/paste\.the-compiler\.org\/view\/raw\/[a-z0-9]{8}\z/,
    ]]
  end

  it "change the last option" do
    a, b = get_current_lines.call.last(2)
    br.keyboard.type :up, :enter
    wait_for_still_frame.call 1, 0.5
    br.keyboard.type :up, :enter
    wait_for_still_frame.call 1, 0.5
    c, d = get_current_lines.call.last(2)
    assert_equal b, d
    refute_equal a, c
  end

end

