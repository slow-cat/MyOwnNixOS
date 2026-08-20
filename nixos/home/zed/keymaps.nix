[
  {
    context = "Workspace";
    bindings = { };
  }
  {
    context = "Editor && vim_mode == insert";
    bindings."j k" = "vim::NormalBefore";
  }
  {
    bindings."cmd-alt-c" = [
      "agent::NewExternalAgentThread"
      { agent = "codex"; }
    ];
  }
]
