-- Change this path to point to VASP folder on your system:
local vasp_base = "/home/oliver/.wine/drive_c/VASP"

-- Set filetype to "amp" for syntax highlighting
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = vasp_base .. "/script/*",
  callback = function()
    vim.bo.filetype = "amp"
  end
})

local M = {}

function M.run_exe(exe_type)
  -- Save the file
  vim.cmd('update')

  -- Change to VASP directory that contains the exe
  vim.cmd('cd ' .. vasp_base)

  -- Start wineserver and keep it running
  vim.fn.system('wineserver -p')
  -- Run the command
  vim.fn.system('WINEDEBUG=-all wine ' .. exe_type .. ' ' .. vim.fn.expand('%'))

  -- Go back to current directory
  vim.cmd('cd -')
end

return M

