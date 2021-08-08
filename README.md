# Paster -- universal asynchronous pastebin CLI

Paster is a CLI tool that can upload your data to multiple pastebins services at the same so you should not worry if some of them went offline or which of them support the options you want such as expiration date or visibility. It uploads asynchronously gracefully skipping failed requests, printing the returned links until done or until you stop the process with `^C`.

## Installation

```bash
gem install paster
```

The tool tries to automatically detect your paste language to behave according to the services' specifics. The gem used for language detection depends on some things so you might need to do something like `brew install icu4c` if it's not installed yet.

## Usage

### Upload sources

* You can pass a file as an argument:
  ```bash
  paster ~/.ssh/id_rsa.pub
  ```
* Or pipe the input:
  ```bash
  ls -l | paster
  ```
* Without argv or pipe it will read from your OS clipboard.

Currently the gem has been tested only on macOS.

### Dialog

```none
$ paster my_code.rb

paste size: 94
preview: "#!/usr/bin/env ruby\nputs ..."
detected language: Ruby

change current options if needed: (Press ↑/↓ arrow to move, Enter to select and letters to filter)
‣ expiration: virtually forever
  visibility: unlisted
  proceed
```

The dialog shows currently selected combination of options.
When you chose one to change the number in `()` means how many pastebin services support them.

```none
...
change current options if needed: expiration: virtually forever
expiration: (Press ↑/↓ arrow to move, Enter to select and letters to filter)
  burn after reading (1)
  5 minutes (1)
  1 hour (2)
  1 day (2)
  3 days (1)
  1 week (1)
  1 month (1)
  3 months (1)
  1 year (1)
‣ virtually forever (3)
```
```none
...
change current options if needed: visibility: unlisted
visibility: (Press ↑/↓ arrow to move, Enter to select and letters to filter)
‣ unlisted (3)
  public (3)
```

Finally when you chose "proceed" it uploads the input printing the URLs in order of getting responses:

```none
...
raw:       http://sprunge.us/Pnc642
formatted: https://paste.the-compiler.org/view/f194cffe
raw:       https://paste.the-compiler.org/view/raw/f194cffe
formatted: https://paste.debian.net/1205711
raw:       https://paste.debian.net/plain/1205711
delete:    https://paste.debian.net/delete/8080846590e7151ad30e47d0584aabf01922f1da
```

### Environment variables

* `LOGLEVEL_Paster` being set to `INFO` or `DEBUG` enriches the output with some debug info.
* `DRYRUN` being set to any value prints the selected options in the end but does not upload.

### Some early version demo GIF

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
- [ ] announce
  - [ ] on reddit
  - [ ] on each existing service channel
- [ ] pastebin options
  - [x] expire
  - [x] raw
  - [x] delete
  - [x] unlisted
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
