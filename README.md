# [WIP] Paster -- universal asynchronous pastebin CLI

For your convenience [I explored](https://github.com/Nakilon/pcbr-demo/blob/master/pastebins.txt) the features of ~30 pastebin services and realised that people want different sets of features so I ~~made~~ am making a CLI that asks what exactly you want and then tries to upload your paste to all conforming pastebins services asynchronously printing the returned links until done or until you stop the process with `^C` and gracefully skipping failed submissions.

## Installation

```bash
gem install paster
```

The tool tries to automatically detect your paste language to behave according to the services' specifics. The gem used for language detection depends on some things so you might need to do something like `brew install icu4c` if it's not installed yet.

## Usage

The following command uploads a file to multiple pastebins printing the URLs in the order of whichever of them was faster to fulfil the request:

```none
$ paster my_code.rb
paste size: 126
https://paste.the-compiler.org/view/f2a7b94f
http://sprunge.us/xIPikX?ruby
...
```

![t-rec_1](https://user-images.githubusercontent.com/2870363/123653688-11005480-d836-11eb-8e07-3a9562c8596f.gif)

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

- [ ] examples for README
  - [x] plain text
  - [ ] terminalizer gif
- [ ] pastebin options
  - [x] expire
  - [ ] raw
- [ ] CLI interfaces
  - [x] tty-prompt
  - [ ] command line options
- [ ] some debug option
- [ ] tests
- [ ] save preferences
- [ ] push to rubygems
- [ ] announce
- [ ] pastebins
  - [x] sprunge.us
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
