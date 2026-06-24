# Building a current tmux without root

Many clusters ship an old tmux. This config needs **>= 3.4**. Build tmux and its
libevent dependency into a user prefix (`~/opt`) and put it on your `PATH`.

```sh
PREFIX="$HOME/opt"
mkdir -p "$PREFIX/src" && cd "$PREFIX/src"

# 1. libevent
curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
tar xzf libevent-2.1.12-stable.tar.gz && cd libevent-2.1.12-stable
./configure --prefix="$PREFIX/libevent" --disable-openssl
make -j"$(nproc)" && make install
cd ..

# 2. tmux
curl -LO https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz
tar xzf tmux-3.5a.tar.gz && cd tmux-3.5a
PKG_CONFIG_PATH="$PREFIX/libevent/lib/pkgconfig" \
  ./configure --prefix="$PREFIX/tmux" \
  CFLAGS="-I$PREFIX/libevent/include" \
  LDFLAGS="-L$PREFIX/libevent/lib -Wl,-rpath,$PREFIX/libevent/lib"
make -j"$(nproc)" && make install

# 3. Put it on PATH. shell/aliases.sh adds ~/bin to PATH, so symlink there:
mkdir -p "$HOME/bin" && ln -sfn "$PREFIX/tmux/bin/tmux" "$HOME/bin/tmux"
```

Requires `ncurses`/`bison` headers. If `configure` cannot find ncurses, build it
into the prefix the same way, or load your system's `ncurses-devel` module.
