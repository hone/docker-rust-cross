# docker-rust-cross
This is a docker container for building cross platform Rust binaries. It sets up the toolchains for Rust and the compilers for cross-compiling.

It sets up a user and group at uid/gid 1000 called 'rust'. The container expects the code to be volume mounted at `/home/rust/code`, which is the `WORKDIR`.

To launch a bash shell to do development, one can do the following:

```
$ docker run -it hone/rust-cross bash
```
