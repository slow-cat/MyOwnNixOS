{ ... }:

{
  programs.wofi = {
    enable = true;
    style = ''
      window {
        margin: 0px;
        border: 1px solid;
      }

      #input {
        margin: 5px;
        border: none;
      }

      #inner-box {
        margin: 5px;
        border: none;
      }

      #outer-box {
        margin: 5px;
        border: none;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
      }
    '';
  };
}
