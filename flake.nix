{
  description = "Discord role duplication tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        duplicate-role = pkgs.writeShellApplication {
          name = "duplicate-role";
          runtimeInputs = [ pkgs.curl pkgs.jq ];
          text = builtins.readFile ./duplicate-role.sh;
        };
      in
      {
        packages = {
          inherit duplicate-role;
          default = duplicate-role;
        };

        apps = {
          duplicate-role = flake-utils.lib.mkApp { drv = duplicate-role; };
          default = self.apps.${system}.duplicate-role;
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.curl pkgs.jq ];
        };
      });
}
