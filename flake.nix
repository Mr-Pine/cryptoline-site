{
  description = "CryptoLine documentation site (Hugo)";

  # Pinned to a release whose Hugo is close to the 0.108.0 used by the Pages
  # workflow in .github/workflows/hugo.yml. The hugo-book theme still calls
  # `resources.ToCSS`, which current Hugo has removed, so do not bump this
  # without updating the theme submodule too.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

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
