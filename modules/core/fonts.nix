{ pkgs, ... }: 

{
  # Configure system fonts
  fonts.packages = with pkgs; [
    # JetBrains Mono - a monospace font with programming ligatures
    nerd-fonts.jetbrains-mono
    # Fira Code - another popular monospace font with programming ligatures
    nerd-fonts.fira-code
  ];
}
