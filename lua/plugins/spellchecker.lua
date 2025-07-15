return {
  'kamykn/spelunker.vim',
  config = function()
    vim.g.enable_spelunker_vim = 1
    vim.g.enable_spelunker_vim_on_readonly = 0
    vim.g.spelunker_target_min_char_len = 4
    vim.g.spelunker_max_suggest_words = 15
    vim.g.spelunker_max_hi_words_each_buf = 100
    vim.g.spelunker_check_type = 2
    vim.g.spelunker_highlight_type = 2
    vim.g.spelunker_disable_uri_checking = 1
    vim.g.spelunker_disable_email_checking = 1
    vim.g.spelunker_disable_account_name_checking = 0
    vim.g.spelunker_disable_acronym_checking = 1
    vim.g.spelunker_disable_backquoted_checking = 0
    vim.g.spelunker_disable_auto_group = 1
    vim.g.spelunker_spell_bad_group = 'SpelunkerSpellBad'
    vim.g.spelunker_complex_or_compound_word_group = 'SpelunkerComplexOrCompoundWord'

    vim.cmd[[autocmd BufRead * if getfsize(@%) > 100000 | let g:enable_spelunker_vim = 0 | endif]]
    -- vim.cmd([[
    --   highlight SpelunkerSpellBad cterm=undercurl ctermfg=NONE gui=undercurl guifg=NONE
    --   highlight SpelunkerComplexOrCompoundWord cterm=undercurl ctermfg=NONE gui=undercurl guifg=NONE
    -- ]])
  end
}
