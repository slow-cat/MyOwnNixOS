{ ... }:

{
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--color=base16"
      "--height=50%"
      "--layout=reverse"
      "--border"
      "--preview-window=right:50%"
      ''--pointer=$(printf '\u25B6')''
      "--bind='alt-/:change-preview-window(65%|80%|hidden),alt-k:preview-half-page-up,alt-j:preview-half-page-down'"
    ];
  };
}
