# `rblake2sum`

A recursive file-system blake2 digest (hash) tool.

Like `sha256sum`, but for directories, and using `blake2`.

The recursive file-system algorihtm used is described in a
underlying library [crev-recursive-digest](https://github.com/crev-dev/recursive-digest).

## Using

```
$ rblake2sum /usr/
f60d19435bb5e859d911c6600dcf96856dfce5de94d4fefd2b2675051ac10fc36dbde87fd86a30eb5224209b47263eb546bd9e3d7bdf64c1f26a7dccf51809af /usr/

$ rblake2sum --help
rblake2sum 0.2.0
Dawid Ciężarkiewicz <dpc@dpc.pw>
Calculate recursive blake2 digest for path or directory

USAGE:
    rblake2sum [FLAGS] [paths]...

FLAGS:
        --base64     
    -h, --help       Prints help information
    -V, --version    Prints version information

ARGS:
    <paths>...
```

## Installing

You can compiles from source, using `cargo`:

```
cargo install rblake2sum
```

or use latest version precompiled binaries.
