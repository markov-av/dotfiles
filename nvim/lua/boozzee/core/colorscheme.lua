-- local status, _ = pcall(vim.cmd, "colorscheme melange")
local status, _ = pcall(vim.cmd, "colorscheme gruvbox-material")
if not status then
  print("Colorscheme not found!")
  return
end
