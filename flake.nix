{
  description = "CryptoLine documentation site (Hugo)";

  # The hugo-book theme needs Hugo 0.158 or newer.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.hugo # extended build: compiles the theme's SCSS
            pkgs.dart-sass
            pkgs.git # needed for the theme submodule
          ];

          shellHook = ''
            echo "hugo $(hugo version | cut -d' ' -f2)"
            echo "Run 'hugo server --navigateToChanged' and open http://localhost:1313/"
          '';
        };
      });

      # The theme lives in a git submodule, which flakes leave out of the
      # source tree unless asked for it: nix build '.?submodules=1'
      packages = forAllSystems (pkgs: {
        default = pkgs.stdenv.mkDerivation {
          name = "cryptoline-site";
          src = self;
          nativeBuildInputs = [ pkgs.hugo pkgs.dart-sass ];
          buildPhase = ''
            hugo --minify --destination $out
          '';
          dontInstall = true;
        };
      });
    };
}
