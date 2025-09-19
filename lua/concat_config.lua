local uv = vim.loop
local config_path = vim.fn.stdpath 'config'
local output_path = config_path .. '/flattened_config.lua'
local root = config_path .. '/lua'

local output = {}

local function scan_dir(dir)
  local handle = uv.fs_scandir(dir)
  if not handle then
    return
  end

  while true do
    local name, type = uv.fs_scandir_next(handle)
    if not name then
      break
    end

    local fullpath = dir .. '/' .. name
    if type == 'directory' then
      scan_dir(fullpath)
    elseif type == 'file' and name:match '%.lua$' then
      table.insert(output, '-- ======= ' .. fullpath:gsub(config_path .. '/', '') .. ' =======\n')
      local lines = vim.fn.readfile(fullpath)
      for _, line in ipairs(lines) do
        table.insert(output, line)
      end
      table.insert(output, '\n\n')
    end
  end
end

scan_dir(root)
vim.fn.writefile(output, output_path)
print('Config concaténée dans : ' .. output_path)
