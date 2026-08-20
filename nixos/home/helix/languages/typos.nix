{ pkgs }:

{
  packages = [ pkgs.typos-lsp ];
  language-server.typos = {
    command = "${pkgs.typos-lsp}/bin/typos-lsp";
    environment.RUST_LOG = "typos-lsp=error";
    config.diagnosticSeverity = "Info";
  };
}
