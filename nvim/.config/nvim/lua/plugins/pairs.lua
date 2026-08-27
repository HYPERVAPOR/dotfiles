return {
  "echasnovski/mini.pairs",
  version = "*",
  event = "InsertEnter",
  config = function()
    require("mini.pairs").setup({
      -- 默认就支持 () [] {} "" '' ``
      -- 这里保持默认，不额外定制
    })
  end,
}
