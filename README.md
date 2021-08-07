# [WIP] Paster -- universal asynchronous pastebin CLI

For your convenience [I explored](https://github.com/Nakilon/pcbr-demo/blob/master/pastebins.txt) the features of ~30 pastebin services and realised that people want different sets of features so I ~~made~~ am making a CLI that asks what exactly you want and then tries to upload your paste to all conforming pastebins services asynchronously printing the returned links until done or until you stop the process with `^C` and gracefully skipping failed submissions.

## Installation

```bash
gem install paster
```

The tool tries to automatically detect your paste language to behave according to the services' specifics. The gem used for language detection depends on some things so you might need to do something like `brew install icu4c` if it's not installed yet.

## Usage

Paster interactively asks you the options and the number in () means how many pastebin services support them.

```none
$ paster my_code.rb
paste size: 94
detected language: Ruby
expiration: (Press ↑/↓ arrow to move, Enter to select and letters to filter)
  burn after reading (2)
  5 minutes (2)
‣ 1 hour (3)
  1 day (3)
  3 days (2)
  1 week (2)
  1 month (2)
  3 months (2)
  1 year (2)
  keep forever (3)
```

Then it uploads a file to multiple pastebins printing the URLs in the order of whichever of them was faster to fulfil the request:

```none
$ paster my_code.rb
paste size: 94
detected language: Ruby
expiration: 1 hour (3)
raw:       http://sprunge.us/Pnc642
formatted: https://paste.the-compiler.org/view/f194cffe
raw:       https://paste.the-compiler.org/view/raw/f194cffe
formatted: https://paste.debian.net/1205711
raw:       https://paste.debian.net/plain/1205711
delete:    https://paste.debian.net/delete/8080846590e7151ad30e47d0584aabf01922f1da
```

You can also pipe the stdout:

```none
$ ls -l | paster
...
```

Without argv or pipe it will consume your OS clipboard.

Some early version demo GIF:
![t-rec_1](https://user-images.githubusercontent.com/2870363/123653688-11005480-d836-11eb-8e07-3a9562c8596f.gif)

The env var `LOGLEVEL_Paster` being set to `INFO` or `DEBUG` enriches the output with some debug info.

## Possible issues

```none
/core_ext/kernel_require.rb:55:in `require': dlopen(.../gems/charlock_holmes-.../lib/charlock_holmes/charlock_holmes.bundle, 9): Library not loaded: /usr/local/opt/icu4c/lib/libicudata.....dylib (LoadError)
```

means Homebrew has upgraded your `icu4c` dynamic library installation and you have to rebuild the following gem:

```bash
gem pristine charlock_holmes
```

TODO: make it able to ignore the missing/broken dependency needed for automatic language detection

## TODO

- [x] examples for README
  - [x] plain text
  - [x] gif
- [ ] CLI interfaces
  - [x] interactive tty-prompt
  - [ ] non-interactive mode
- [x] some debug option
- [x] push to rubygems
- [ ] save preferences
- [ ] tests
  - [ ] webmock to get rid of nethttputils
- [ ] announce
  - [ ] on reddit
  - [ ] on each existing service channel
- [ ] pastebin options
  - [x] expire
  - [x] raw
  - [ ] unlisted
  - [ ] ...
- [ ] pastebins
  - [x] sprunge.us
  - [ ] powered by Stikked
    - [x] paste.the-compiler.org
  - [ ] paste.debian.net
    - [x] multipart/form-data
    - [ ] XML RPC
  - [ ] pastebin.com
  - [ ] dpaste.com
  - [ ] paste.org.ru
  - [ ] gist.github.com
  - [ ] dpaste.org
  - [ ] ix.io
  - [ ] vpaste.net
  - [ ] termbin.com
  - [ ] 0x0.st
  - [ ] clbin.com
  - [ ] paste.rs
  - [ ] pastefy.ga
  - [ ] p.6core.net
  - [ ] bpa.st
  - [ ] bsd.to
  - [ ] paste.tomsmeding.com
  - [ ] paste.nginx.org
  - [ ] envs.sh
