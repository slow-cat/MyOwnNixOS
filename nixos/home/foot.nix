{ ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        letter-spacing = "1px";
      };

      scrollback = {
        lines = 10000;
        multiplier = 6.0;
      };

    };
  };
}
