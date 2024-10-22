-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function custom()
  local keyset = vim.keymap.set

  keyset("i", "jj", "<Esc>", { silent = true })
  keyset("i", "jk", "<Esc>:w<CR>", { silent = true })
  -- keyset("n", "<A-h>", "^", { silent = true })
  -- keyset("n", "<A-l>", "$", { silent = true })

  keyset("v", "<leader>l", ":<C-u>lua AddConsoleLog()<CR>", { noremap = true, silent = true })
  keyset("n", "<leader>l", "viw:<C-u>lua AddConsoleLog()<CR>", { noremap = true, silent = true })

  -- 生成随机颜色的函数
  local function generate_random_color()
    local hex = "0123456789ABCDEF"
    local color = "#"
    for _ = 1, 6 do
      local index = math.random(1, 16)
      color = color .. hex:sub(index, index)
    end
    return color
  end

  -- 定义函数 AddConsoleLog
  function AddConsoleLog()
    -- 获取视觉模式下选中的文本
    local start_line, start_col = unpack(vim.fn.getpos("'<"), 2, 3)
    local end_line, end_col = unpack(vim.fn.getpos("'>"), 2, 3)
    local selected_text = vim.fn.getline(start_line, end_line)

    if #selected_text == 0 then
      return
    end

    if #selected_text == 1 then
      selected_text = selected_text[1]:sub(start_col, end_col)
    else
      selected_text[1] = selected_text[1]:sub(start_col)
      selected_text[#selected_text] = selected_text[#selected_text]:sub(1, end_col)
      selected_text = table.concat(selected_text, "\n")
    end

    -- 生成随机颜色
    local random_color = generate_random_color()

    -- 获取行号
    local line_number = vim.fn.line(".")

    -- 构造要插入的 console.log 语句
    local line_to_insert = 'console.log("%c Line:'
      .. line_number
      .. " 🥛 "
      .. selected_text
      .. '", "color:'
      .. random_color
      .. '", '
      .. selected_text
      .. ");"

    -- 将插入行的命令送入命令行
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("o" .. line_to_insert .. "<Esc>", true, false, true),
      "n",
      true
    )
  end
end

custom()
