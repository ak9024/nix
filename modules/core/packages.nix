{ pkgs, lib, ... }: 

{
  # Make sure Node.js modules are accessible globally
  environment.variables = {
    # Ensure global npm packages are accessible
    NODE_PATH = "${pkgs.nodejs_23}/lib/node_modules";
  };

  # Prepend node executables to PATH
  environment.extraInit = ''
    # Ensure npm global bin directory is in PATH
    export PATH=$HOME/.npm/bin:$PATH
  '';

  # System packages configuration
  environment.systemPackages = with pkgs; [
    # Text editors and shell enhancements
    neovim
    oh-my-zsh
    pure-prompt
    
    # ZSH plugins and extensions
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    
    # Version control tools
    git
    delta  # Enhanced git diff viewer
    
    # Container and orchestration tools
    colima      # Container runtime for macOS
    docker_26
    podman
    podman-compose
    minikube    # Local Kubernetes
    k9s         # Kubernetes CLI UI
    
    # Programming languages and development tools
    rustc
    cargo
    go
    nodejs_23
    go-migrate  # Database migration tool
    cmake
    pkg-config
    bun
    
    # CLI utilities
    wget
    curl
    htop        # Interactive process viewer
    jq          # JSON processor
    tldr        # Simplified man pages
    tree        # Directory structure viewer
    neofetch    # System information tool
    protobuf_27

    # Security and encryption tools
    openssl     # Cryptographic library and tools
    sops        # Secrets management
  ];
}

