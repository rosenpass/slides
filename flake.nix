{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs =
          import nixpkgs {
            inherit system;
            overlays = [ devshell.overlays.default ];
          };
      in
      {
        devShells.default = (pkgs.devshell.mkShell {
          imports = [ "${devshell}/extra/git/hooks.nix" ];
          name = "rosenpass-slides-dev-shell";
          packages = with pkgs; [
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-basic amsfonts beamer babel-german tcolorbox emoji environ
                ccicons csquotes csvsimple doclicense fancyvrb fontspec gobble
                koma-script ifmtarg latexmk lm markdown mathtools minted noto
                nunito pgf soul unicode-math lualatex-math gitinfo2 eso-pic
                biblatex biblatex-trad biblatex-software xkeyval xurl xifthen
                biber;
            })
          ];
          git.hooks = {
            enable = true;
            pre-commit.text = ''
              nix flake check
            '';
          };
          commands = [
            {
              name = "build";
              command = ''
                latexmk
              '';
              help = "build the slides";
            }
            {
              name = "clean";
              command = ''
                latexmk -c
              '';
              help = "build the slides";
            }
          ];
        });
      }
    );
}
