{ pkgs, ... }:

let
  nixdConfig = {
    nixpkgs.expr = "import <nixpkgs> { }";

    formatting.command = [ "nixfmt" ];

    options = {
      nixos.expr = "(import <nixpkgs/nixos> { configuration = /etc/nixos/configuration.nix; }).options";

      home_manager.expr = "(import <nixpkgs/nixos> { configuration = /etc/nixos/configuration.nix; }).options.home-manager.users.type.getSubOptions []";
    };
  };
in
{
  programs.zed-editor = {
    enable = true;

    # Keep settings/keymaps declarative rather than letting Zed rewrite them.
    mutableUserSettings = false;
    mutableUserKeymaps = false;

    # Nix language support.  The extension supplies the Nix grammar/LSP adapter;
    # the binaries themselves come from the same NixOS generation.
    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "typos"
      "vale"
    ];
    extraPackages = [
      pkgs.nixd
      pkgs.nixfmt
      pkgs.taplo

      (pkgs.vale-ls.override {
        vale = (pkgs.vale.withStyles (s: [ s.google ]));
      })
    ];

    userSettings = {
      project_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";
      git_panel.dock = "left";

      agent_servers = {
        codex = {
          type = "custom";
          command = "${pkgs.codex-acp}/bin/codex-acp";
          args = [ ];
          env = { };
        };
      };

      agent = {
        dock = "right";
        favorite_models = [ ];
        model_parameters = [ ];
      };

      scroll_sensitivity = 4.0;
      fast_scroll_sensitivity = 12.0;

      helix_mode = true;
      vim_mode = false;

      icon_theme = "Zed (Default)";

      theme = {
        mode = "dark";
        dark = "Catppuccin Frappé";
        light = "Catppuccin Latte";
      };

      languages.Nix = {
        language_servers = [
          "nixd"
          "typos"
          "nil"
        ];
        formatter = "language_server";
        format_on_save = "on";
      };
      languages.Markdown = {
        language_servers = [
          "typos"
          "vale"
        ];
      };

      lsp = {
        vale = {
          binary = {
            path = "${pkgs.vale-ls}/bin/vale-ls";
          };
        };
        nixd = {
          binary = {
            path = "${pkgs.nixd}/bin/nixd";
            arguments = [ ];
          };
          settings.nixd = nixdConfig;
        };
        nil = {
          binary = {
            path = "${pkgs.nil}/bin/nil";
            arguments = [ ];
          };
          settings.nixd = nixdConfig;
        };
        typos = {
          binary = {
            path = "${pkgs.typos-lsp}/bin/typos-lsp";
            arguments = [ ];
            env = {
              RUST_LOG = "typos-lsp=error";
            };
          };
          initialization_options = {
            diagnosticSeverity = "Information";
          };
          settings.nixd = nixdConfig;
        };
      };
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = { };
      }
      {
        # Preserved from the original keymap.  It is inactive while vim_mode=false.
        context = "Editor && vim_mode == insert";
        bindings = {
          "j k" = "vim::NormalBefore";
        };
      }
      {
        bindings = {
          "cmd-alt-c" = [
            "agent::NewExternalAgentThread"
            { agent = "codex"; }
          ];
        };
      }
    ];
  };
}
