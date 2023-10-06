{
  description = "A recursive blake2 digest (hash) of a file-system path";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    flakebox = {
      url = "github:rustshop/flakebox?rev=3fa3fd9f98cb8cb842b0f60cb5b2ed9314727e6a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, flakebox }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        projectName = "rblake2sum";

        flakeboxLib = flakebox.lib.${system} {
          config = {
            github.ci.buildOutputs = [ ".#ci.rblake2sum" ];
            typos.pre-commit.enable = false;
          };
        };

        buildPaths = [
          "Cargo.toml"
          "Cargo.lock"
          ".cargo"
          "src"
        ];

        buildSrc = flakeboxLib.filterSubPaths {
          root = builtins.path {
            name = projectName;
            path = ./.;
          };
          paths = buildPaths;
        };

        multiBuild =
          (flakeboxLib.craneMultiBuild { }) (craneLib':
            let
              craneLib = (craneLib'.overrideArgs {
                pname = "flexbox-multibuild";
                src = buildSrc;
              });
            in
            {
              rblake2sum = craneLib.buildPackage { };
            });
      in
      {
        packages.default = multiBuild.rblake2sum;

        legacyPackages = multiBuild;

        devShells = {
          default = flakeboxLib.mkDevShell {
            packages = [ ];
          };
        };
      }
    );
}
