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
  programs.helix = {
    enable = true;

    extraPackages = [
      pkgs.nixd
      pkgs.nixfmt
    ];

    settings = {
      theme = "moamoa";

      editor.inline-diagnostics.cursor-line = "hint";

      keys.normal = {
        Y = [
          ":clipboard-yank"
          "yank"
        ];
        D = [
          ":clipboard-yank"
          "yank"
          "delete_selection"
        ];
        P = ":clipboard-paste-after";
        "C-r" = "redo";
        J = ":buffer-next";
        K = ":buffer-previous";
        "A-r" = ":sh exec $(realpath %{buffer_name})";
        "A-s" = ":sh adb push %{buffer_name} /sdcard/Download";
        "A-x" = ":sh chmod +x %{buffer_name}";

        "+" = {
          p = '':sh sh -c 'pdf=$(basename -- "$1"); pdf=''${pdf%%.*}.pdf; pkill -f "zathura $pdf" >/dev/null 2>&1 || zathura "$pdf" >/dev/null 2>&1' sh "%{buffer_name}"'';
          a = [
            ":w"
            '':sh sh -c 'cargo compete test "$(basename -- "$1" .rs)"' sh "%{buffer_name}"''
          ];
          r = [
            ":config-open"
            ":w"
            ":config-reload"
          ];
        };
      };

      keys.insert = {
        j.k = "normal_mode";
        k.j = "normal_mode";
        "C-[" = "normal_mode";

        "C-i" = "insert_tab";
        "C-S-i" = "unindent";
        "S-tab" = "unindent";

        "C-c" = "toggle_comments";

        "C-m" = "open_below";
        "C-j" = "insert_newline";

        "C-b" = "move_char_left";
        "C-f" = "move_char_right";

        "A-b" = [
          "move_prev_word_start"
          "move_char_left"
          "move_char_right"
        ];
        "A-f" = [
          "move_next_word_start"
          "move_char_right"
        ];

        "C-a" = "goto_line_start";
        "C-e" = "goto_line_end";

        "C-h" = "delete_char_backward";
        "C-/" = "delete_char_forward";

        "A-d" = "delete_word_backward";
        "A-backspace" = "delete_word_backward";
        "C-w" = "delete_word_forward";
        "A-del" = "delete_word_forward";

        "C-u" = [
          "move_char_left"
          "select_mode"
          "goto_line_start"
          "delete_selection"
          "insert_mode"
        ];
        "C-k" = [
          "select_mode"
          "goto_line_end"
          "delete_selection"
          "insert_mode"
        ];

        "C-x" = {
          u = "undo";
          r = "redo";
          x = "completion";
          "C-x" = "completion";
        };

        "C-y" = "paste_after";
        "C-space" = "select_mode";
        "C-@" = "select_mode";
      };

      keys.select = {
        Y = [
          ":clipboard-yank"
          "yank"
        ];
        D = [
          ":clipboard-yank"
          "yank"
          "delete_selection"
        ];
        P = ":clipboard-paste-after";
      };
    };

    languages = {
      language-server = {
        # clasangd = {
        #   command = "clasangd";
        #   args = [ "-v" "1" ];
        # };

        clangd = {
          command = "clangd";
          args = [ "--compile-commands-dir=./builddir" ];
        };

        texlab.command = "texlab";
        tinymist.command = "tinymist";
        jdtls.command = "jdtls";

        typos = {
          command = "typos-lsp";
          environment.RUST_LOG = "error";
          config.diagnosticSeverity = "Info";
        };

        vale.command = "vale-ls";

        ruff.command = "ruff";
        ty.command = "ty";

        rust-analyzer = {
          command = "rustup";
          args = [
            "run"
            "nightly"
            "rust-analyzer"
          ];
          config = {
            checkOnSave.enable = true;
            procMacro.enable = true;
            cargo = {
              enable = true;
              buildScripts.enable = true;
            };
            files.excludeDirs = [
              "target"
              ".git"
              ".direnv"
            ];
          };
        };

        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
          config.nixd = nixdConfig;
        };
      };

      language = [
        {
          name = "nix";
          language-servers = [
            "nixd"
            "typos"
          ];
        }
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "typos"
          ];
        }
        {
          name = "c";
          language-servers = [
            "clangd"
            "typos"
          ];
        }
        {
          name = "cpp";
          language-servers = [
            "clangd"
            "typos"
          ];
        }
        {
          name = "java";
          language-servers = [
            "jdtls"
            "typos"
          ];
        }
        {
          name = "python";
          language-servers = [
            "ruff"
            "typos"
            "ty"
          ];
        }
        {
          name = "bash";
          language-servers = [ "typos" ];
        }
        {
          name = "latex";
          language-servers = [
            "texlab"
            "typos"
            "vale"
          ];
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "`" = "`";
            "\"" = "\"";
            "$" = "$";
          };
        }
        {
          name = "typst";
          language-servers = [
            "tinymist"
            "typos"
            "vale"
          ];
        }
        {
          name = "markdown";
          language-servers = [
            "typos"
            "vale"
          ];
        }
      ];

      grammar = [
        {
          name = "haskell";
          source = {
            git = "https://github.com/tree-sitter-grammars/tree-sitter-haskell";
            rev = "98aedbd2d6947a168ba3ba3755d70b0cb6b78395";
          };
        }
      ];
    };

    themes.moamoa = {
      inherits = "term16_dark";
      "ui.selection" = {
        bg = "white";
        fg = "black";
      };
    };
  };
}
