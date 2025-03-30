{ pkgs, ... }: {
  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    oh-my-zsh
    neovim
    tmux
    fzf-zsh
    git
    colima
    docker_26
    delta
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    cargo
    rustc
    cmake
    openssl
    pkg-config
    go
    nodejs_23
    minikube
    k9s
    tldr
    wget
    htop
    jq
  ];
}
