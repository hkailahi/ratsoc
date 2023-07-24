# ratsoc

## Pre-Interview Setup

1. Setup environment with [`devenv`](https://devenv.sh/)

  * Following [guide](https://devenv.sh/guides/using-with-flakes/), initialize `devenv` via flake template
    * Run `nix flake init --template github:cachix/devenv`
  * Add `.devenv` and `.direnv` to `.gitignore`
  * Update package set
```diff
  inputs = {
-   nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
+   nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };
```
  * Enable `direnv`
    * Run `direnv allow`

1. Configure basic Haskell project skeleton

* Add `ghc-9.4.5` compiler, `stack` build tool, `haskell-language-server` IDE, and `ormolu` formatter to `flake.nix`
```diff
   default = devenv.lib.mkShell {
     inherit inputs pkgs;
     modules = [
       {
          # https://devenv.sh/reference/options/
          packages = [ pkgs.hello ];

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
