return {
  {
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    -- NOTE: don't need to load beffore VeryLazy if opts.virtualtext.auto_trigger_ft != "*"
    events = "LazyFile",
    ---@module "minuet"
    opts = {
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = { "snacks_picker_input" },
        keymap = {
          accept = "<A-y>",
          accept_line = "<A-a>",
          prev = "<A-p>",
          next = "<A-n>",
          dismiss = "<A-e>",
        },
      },
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 8192,
      throttle = 50,
      debounce = 50,
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "granite-code:8b-base",
          optional = {
            stop = "\n", -- Single-line completion
            max_tokens = 128,
            top_p = 0.9,
          },
          template = {
            prompt = function(pref, suff)
              local prompt_message = ""
              for _, file in ipairs(require("vectorcode.cacher").query_from_cache(0)) do
                prompt_message = prompt_message .. "<file_separator>" .. file.path .. "\n" .. file.document
              end
              return prompt_message .. "<fim_prefix>" .. pref .. "<fim_suffix>" .. suff .. "<fim_middle>"
            end,
            suffix = false,
          },
        },
      },
    },
  },
  {
    "Davidyz/VectorCode",
    enabled = false,
    lazy = true,
    version = "*",
    build = "pipx upgrade vectorcode",
    opts = {
      -- n_query = 10,
    },
    init = function(_)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local cacher = require("vectorcode.cacher")
          cacher.async_check("config", function()
            ---@diagnostic disable-next-line: missing-fields
            cacher.register_buffer(event.buf, {
              n_query = 10,
              query_cb = require("vectorcode.utils").make_lsp_document_symbol_cb()
                or require("vectorcode.utils").make_surrounding_lines_cb(-1),
              events = { "BufWritePost" },
              debounce = 15,
            })
          end, nil)
        end,
        desc = "Register buffer for VectorCode",
      })
    end,
  },
}
