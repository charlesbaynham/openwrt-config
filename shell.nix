{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  buildInputs = with pkgs; [ 
    envsubst
    git-crypt
    gnupg
  ];
  shellHook = ''
    echo Initiating git-crypt
    # git-crypt unlock
  '';
}
