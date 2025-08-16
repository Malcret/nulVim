return {
  {
    "rmagatti/auto-session",
    lazy = false,
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = {
        "/",
        "/tmp",
        "~/",
        "~/.config",
        ".cache",
      },
      bypass_save_filetypes = { "oil" },
      -- NOTE: Oil need to load after, so we force load it once the restore process is done.
      no_restore_cmds = {
        function() require("oil").setup(nulVim.get_plugin_opts("oil")) end,
      },
      post_restore_cmds = {
        function() require("oil").setup(nulVim.get_plugin_opts("oil")) end,
      },
    },
    keys = nulVim.config.keymaps.auto_session,
  },
}
