return {
  'numToStr/Comment.nvim',
  opts = {
    ignore = "^$",
    mappings = {
      basic = true,
      extra = true,
    },
    toggler = {
      line = ',,',
      block = 'gbc',
    },
    opleader = {
      line = ',',
      block = 'gbc',
    },
    extra = {
      above = ',O',
      below = ',o',
      eol = ',A',
    },
  }
}

