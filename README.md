# ratsoc

## Pre-Interview Setup

1. Setup environment with [`devenv`](https://devenv.sh/)

  * Following [guide](https://devenv.sh/guides/using-with-flakes/), initialize `devenv` via flake template
    * Run `nix flake init --template github:cachix/devenv`
  * Add `.devenv` and `.direnv` to `.gitignore`
  * Update package set and revert to working `devenv` commit
```diff
  inputs = {
-   nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
+   nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
-    devenv.url = "github:cachix/devenv";
+    devenv.url = "github:cachix/devenv/9b6566c51efa2fdd6c6e6053308bc3a1c6817d31";  # avoid bug https://github.com/cachix/devenv/issues/752
  };
```
  * Enable `direnv`
    * Run `direnv allow`

2. Configure basic Haskell project skeleton

* Add `ghc-9.4.5` compiler, `stack` build tool, `haskell-language-server` IDE, and `ormolu` formatter to `flake.nix`
  * Note that overridden `haskell-language-server` to use `ghc-9.4.5` takes a long time to build
```diff
   default = devenv.lib.mkShell {
     inherit inputs pkgs;
     modules = [
       {
          # https://devenv.sh/reference/options/
-         packages = [ pkgs.hello ];
+         packages = with pkgs; [
+           ormolu
+         ];

-         enterShell = ''
-           hello
-         '';
+         languages.haskell.enable = true;
+         languages.haskell.package = pkgs.haskell.compiler.ghc94; # https://www.stackage.org/lts-21.4
+         languages.haskell.languageServer = pkgs.haskell-language-server.override
+           {
+             supportedGhcVersions = [ "94" ];
+           };
+         languages.haskell.stack = pkgs.stack;  # v2.9.1
+         pre-commit.hooks.ormolu.enable = true;
       }
     ];
   };
```

3. Initialize `stack` project

```bash
$ stack new ratsoc
```