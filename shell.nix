{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  buildInputs = with pkgs; [ 
    envsubst
    git-crypt
    gnupg
  ];
}
