# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
   home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in


{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # GRUB 
boot.loader = {
	grub = {
	enable = true;
	devices = ["nodev"];
	efiSupport = true;
	useOSProber = true;
	#configuratonLimit = 5;
	};
	
	efi = {
	canTouchEfiVariables = true;
	efiSysMountPoint = "/boot";
	};
};

  # Hostname
  networking.hostName = "destroyer"; # Define your hostname.

  # Network
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   i18n.extraLocaleSettings = {
	LC_TIME = "sv_SE.utf8";
	LC_MONETARY = "sv_SE.utf8";
}; 
   console = {
     font = "Lat2-Terminus16";
     keyMap = "sv-latin1";
};


services = {
  xserver = {
   enable = true;
	displayManager.lightdm.enable = true;
	windowManager.dwm.enable = true;
	windowManager.spectrwm.enable = true;
   videoDrivers = [ "nvidia" ];

  # Keymap
  layout = "se";
  xkbVariant = "nodeadkeys";
  };
  
  picom = {
	enable = true;
	vSync = true;
  };

};

nixpkgs.overlays = [
	(final: prev: {
		dwm = prev.dwm.overrideAttrs (old: { src = builtins.fetchGit "https://github.com/dwm"; });
	})
];


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fool = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
     #packages = with pkgs; [
     #];
 };

nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
	# Dev
	git
	gh
	wget
	# Editor
	neovim
	# Browser
	firefox
	# terminal
	alacritty
	st
	# terminal utils
	exa
	# Menu
	rofi
	# Audio
	pulsemixer
	# Drives
	ntfs3g
	fuse
	# Password Manager
	bitwarden
	# Media
	sxiv
	mpv
	zathura
	# Other
	devour
	wine
	lutris
	steam
	ranger
	virt-manager
	yajl
	jsoncpp
	cmake

  ];


  hardware.opengl.driSupport32Bit = true;

  fonts.fonts = with pkgs; [
	nerdfonts

  ];


programs.bash.promptInit = ''
		PS1="\[\e[0;1;31m\][\[\e[0;1;38;5;37m\]\u\[\e[0;1;31m\]] \[\e[0;38;5;73m\]\W\[\e[0;1m\] ♠ \[\e[0m\]"
		'';


   home-manager.users.fool = {

	programs = {
		bash.enable = true;
				bash.shellAliases = {
			ls = "exa";
			ll = "exa -l";
			l = "exa -la";

			vim = "nvim";

			c = "clear";
			e = "exit";
			df = "df -h";
			".." = "cd ..";
			"..." = "cd ../..";

			dmpv = "devour mpv";
			sxiv = "devour sxiv";
			pdf = "devour zathura";
			
			nix-config = "sudo nvim /etc/nixos/configuration.nix";
			nix-switch = "sudo nixos-rebuild switch";

		};

	};

   };
virtualisation.libvirtd.enable = true;
programs.dconf.enable = true;
boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

