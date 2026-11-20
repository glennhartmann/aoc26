{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-compat, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        manifest = (pkgs.lib.importTOML ./Cargo.toml).package;
        aoc26 = pkgs.rustPlatform.buildRustPackage {
          pname = manifest.name;
          version = manifest.version;
          src = builtins.path { path = ./.; name = "aoc26"; };

          cargoLock = {
            lockFile = ./Cargo.lock;
            outputHashes = {
              "aoclib-rs-0.0.17" = "sha256-U69zebJNOYAiycm/F0qx5HuuFCT0uHX/pfL07qN3Onw=";
            };
          };
        };
        aoc26-shell = pkgs.mkShell {
          inputsFrom = [ aoc26 ];
          packages = with pkgs; [
            clippy
            rustfmt
          ];
        };
      in
      {
        packages = {
          inherit aoc26;
          default = aoc26;
        };
        devShells = {
          inherit aoc26-shell;
          default = aoc26-shell;
        };
      }
    );
}
