# `rblake2sum`

A recursive file-system blake2 digest (hash) tool.

Like `sha256sum` (or rather, less known `blake2`-based: `b2sum`), but for directories.

The recursive file-system algorithm used is described in a
underlying library [crev-recursive-digest](https://github.com/crev-dev/recursive-digest).

Under the hood, it uses [`walkdir`](https://crates.io/crates/walkdir) and
[`blake2`](https://crates.io/crates/blake2), with efficient IO handling, which makes
it fast.

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

You can compile from source, using `cargo`:

```
cargo install rblake2sum
```

or use [precompiled release binaries](https://github.com/crev-dev/rblake2sum/releases).

## Notes

This tool calculates a digest of a *content of a path*. To illustrate:

```
$ mkdir a
$ touch a/file
$ cp -r a b
$ rblake2sum a b
3ecc0360bcfc32fd672443ecbe9b7e278be9e0a731cfedb4ada782bf9753ddd8768d467fcb7ee0b6e5920d1fe3352a6314f2ba73f3cfb3eed7c1a88dfe92cc38 a
3ecc0360bcfc32fd672443ecbe9b7e278be9e0a731cfedb4ada782bf9753ddd8768d467fcb7ee0b6e5920d1fe3352a6314f2ba73f3cfb3eed7c1a88dfe92cc38 b
```

Different path, same content. However:

```
$ mv a/file a/differentfile
$ rblake2sum a
6e4a518652881f356d863ae034e7508648455536e5393824b5cc96232786a4733ffb9c3cdd62bda4741ca0bfe60a181f6ae47959ceb0493716699e9b28f686ac a
```

The name of the files or directories in the path is a part of its content.


In the simplest case, a `rblake2sum` of a file is like a normal `b2sum` of the content, except
prefixed with an `F` (to denote the type of the path). To illustrate:

```
$ echo -en "F" > f
$ cat f differentfile | hexdump -C /dev/stdin
00000000  66                                                |f|
00000001
$ cat f differentfile | b2sum /dev/stdin
c4df78482e7b82e1eea4026a9f61732a62a15a1741737a539733713c2beb3e0057f076934e9fb60646771a4d9084d32a8e48fe838108a842262cf2aad996fa26  /dev/stdin
$ rblake2sum differentfile
c4df78482e7b82e1eea4026a9f61732a62a15a1741737a539733713c2beb3e0057f076934e9fb60646771a4d9084d32a8e48fe838108a842262cf2aad996fa26 differentfile
$ echo "foobar" > file
$ cat f file | b2sum /dev/stdin
96178099394650380ee4bb34aed2eae3ef7a7782adbec3a9aeb436697544b63ed0218ff1240ea1823539183c5e183f211fa8d092bfebe351dc34f77047bceeec  /dev/stdin
$ rblake2sum file
96178099394650380ee4bb34aed2eae3ef7a7782adbec3a9aeb436697544b63ed0218ff1240ea1823539183c5e183f211fa8d092bfebe351dc34f77047bceeec file
```
