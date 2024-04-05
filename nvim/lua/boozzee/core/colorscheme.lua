local status, _ = pcall(vim.cmd, "colorscheme melange")
if not status then
  print("Colorscheme not found!")
  return
end
