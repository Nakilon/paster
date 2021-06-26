# [WIP] Paster -- universal asynchronous pastebin CLI

For your convenience [I explored](https://github.com/Nakilon/pcbr-demo/blob/master/pastebins.txt) the features of a few dozen of pastebin services and realised that people want different sets of them so I ~~made~~ am making a CLI that asks what exactly you want and then tries to upload your paste to all the pastebin services that provide API asynchronously printing the returned links until done or until you stop the process with `^C`.

## Possible issues

```none
/core_ext/kernel_require.rb:55:in `require': dlopen(.../gems/charlock_holmes-.../lib/charlock_holmes/charlock_holmes.bundle, 9): Library not loaded: /usr/local/opt/icu4c/lib/libicudata.....dylib (LoadError)
```

means Homebrew has upgraded your `icu4c` dynamic library installation and you have to rebuild one gem:

```bash
gem pristine charlock_holmes
```

TODO: make it able to ignore the missing/broken dependency needed for automatic language detection
