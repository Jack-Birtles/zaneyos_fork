{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    # hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    # hyprpanel.inputs.nixpkgs.follows = "nixpkgs";
    ghostty-hm = {
      url = "github:clo4/ghostty-hm-module";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    #hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    { nixpkgs, home-manager, zen-browser, nur, ghostty, ghostty-hm, ... }@inputs:
    let
      system = "aarch64-linux";
      host = "jack";
      username = "jack";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };

          modules = [
            nur.modules.nixos.default
            ./hosts/${host}/config.nix

            inputs.stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ];
        };
      };
    };
}
