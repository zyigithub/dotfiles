{
  description = "Home Manager configuration of zyi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "zyi";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
          };

          modules = [
            ./configuration.nix
            ./virt.nix

            home-manager.nixosModules.home-manager

            {
              home-manager = {
                backupFileExtension = "backup";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs;
                };
                users.${username} = {
                  home.username = username;
                  home.homeDirectory = "/home/${username}";
                  imports = [
                    ./ags.nix
                    ./home.nix

                  ];
                };
              };
            }
          ];
        };
      };

    };
}
