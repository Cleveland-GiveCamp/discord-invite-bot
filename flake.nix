{
  description = "Discord role management tools";

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

        set-folder-permissions = pkgs.writeShellApplication {
          name = "set-folder-permissions";
          runtimeInputs = [ pkgs.curl pkgs.jq ];
          text = builtins.readFile ./set-folder-permissions.sh;
        };
      in
      {
        packages = {
          inherit duplicate-role set-folder-permissions;
          default = duplicate-role;
        };

        apps = {
          duplicate-role       = flake-utils.lib.mkApp { drv = duplicate-role; };
          set-folder-permissions = flake-utils.lib.mkApp { drv = set-folder-permissions; };
          default = self.apps.${system}.duplicate-role;
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.curl pkgs.jq ];
        };
      });
}
