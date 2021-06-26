# [WIP] Paster -- universal asynchronous pastebin CLI

For your convenience [I explored](https://github.com/Nakilon/pcbr-demo/blob/master/pastebins.txt) the features of a few dozen of pastebin services and realised that people want different sets of them so I ~~made~~ am making a CLI that asks what exactly you want and then tries to upload your paste to all the pastebin services that provide API asynchronously printing the returned links until done or until you stop the process with `^C`.

## Usage

The following command uploads a file to two pastebins printing the URLs in the order of whichever of them was faster to fulfil the request:

```none
$ paster my_code.rb
paste size: 126
https://paste.the-compiler.org/view/f2a7b94f
http://sprunge.us/xIPikX?ruby
```

The tool automatically detects your paste language and behaves according to pastebin services specifics. In case of "the-compiler" pastebin adds `ruby` to HTTP API call, in case of "sprunge" just appends `?ruby` it to resulting URL.

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

- [x] usage example
- [ ] tests
- [ ] options
- [ ] tty-prompt powered dialog
- [ ] save preferences
- [ ] push to rubygems
- [ ] announce
- [ ] APIs
  - [ ] pastebin.com
  - [ ] dpaste.com
  - [ ] paste.org.ru
  - [x] sprunge.us
  - [ ] gist.github.com
  - [ ] paste.debian.net
  - [ ] dpaste.org
  - [ ] ix.io
  - [ ] vpaste.net
  - [x] paste.the-compiler.org
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
