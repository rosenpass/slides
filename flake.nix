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
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-basic amsfonts beamer babel-german tcolorbox emoji environ
            ccicons csquotes csvsimple doclicense fancyvrb fontspec gobble
            koma-script ifmtarg latexmk lm markdown mathtools minted noto
            nunito pgf relsize soul unicode-math lualatex-math gitinfo2
            eso-pic biblatex biblatex-trad biblatex-software xkeyval xurl
            xifthen biber dirtytalk tikzsymbols pgfornament pgfopts bbding
            transparent pdfpc hyperxmp luacode luatexbase adjustbox
            tikzfill caption;
        };

        documents = (builtins.fromTOML (builtins.readFile ./documents.toml)).documents;
      in
      {
        packages = builtins.listToAttrs (
          builtins.map
            ({ name, ... } @ meta:
              {
                inherit name;
                value = pkgs.stdenvNoCC.mkDerivation {
                  inherit name;
                  srcs = [ (./. + "/${name}") ./tex ];
                  sourceRoot = "./${name}";
                  nativeBuildInputs = with pkgs; [
                    google-fonts
                    tex
                  ];
                  buildPhase = ''
                    export HOME=$(mktemp -d)
                    latexmk
                  '';
                  installPhase = ''
                    mkdir --parent -- $out
                    mv *.pdf $out/
                  '';
                  passthru = meta;
                };
              }
            )
            documents);

        devShells.default = (pkgs.devshell.mkShell {
          imports = [ "${devshell}/extra/git/hooks.nix" ];
          name = "rosenpass-slides-dev-shell";
          packages = with pkgs; [ tex nixpkgs-fmt google-fonts nodePackages.prettier ];
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

        checks = {
          nixpkgs-fmt = pkgs.runCommand "check-nixpkgs-fmt"
            { nativeBuildInputs = [ pkgs.nixpkgs-fmt ]; } ''
            nixpkgs-fmt --check ${./.} && touch $out
          '';
          prettier-check = pkgs.runCommand "check-with-prettier"
            { nativeBuildInputs = [ pkgs.nodePackages.prettier ]; } ''
            cd ${./.} && prettier --check . && touch $out
          '';

          # 1. for every folder that is not hidden there must be a package
          # consistency-check = pkgs.runCommand "check-consistency"
          #   { nativeBuildInputs = [ ]; } ''
          #   cd ${./.}
          #   find -mindepth 1 -maxdepth 1 -type d -not -path '*/.*'
          # '';
        };
      }
    );
}
