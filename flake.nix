{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv/9b6566c51efa2fdd6c6e6053308bc3a1c6817d31";  # avoid bug https://github.com/cachix/devenv/issues/752
  };

  # nixConfig = {
  #   extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  #   extra-trusted-substituters = "https://devenv.cachix.org";
  # };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [
                    ormolu
                  ];

                  languages.haskell.enable = true;
                  languages.haskell.package = pkgs.haskell.compiler.ghc94; # https://www.stackage.org/lts-13.7
                  languages.haskell.languageServer = pkgs.haskell-language-server.override
                    {
                      supportedGhcVersions = [ "94" ];
                    };
                  languages.haskell.stack = pkgs.stack; # stack 2.9.1
                  pre-commit.hooks.ormolu.enable = true;
                }
              ];
            };
          });
    };
}
