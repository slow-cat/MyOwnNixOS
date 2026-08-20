{ helixTypos, helixVale }:

{
  vale.binary.path = helixVale.language-server.vale.command;

  typos = {
    binary = {
      path = helixTypos.language-server.typos.command;
      arguments = [ ];
      env = helixTypos.language-server.typos.environment;
    };
    initialization_options.diagnosticSeverity = "Information";
  };
}
