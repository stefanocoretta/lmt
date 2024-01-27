code_blocks = {}

function CodeBlock (block)
  local this_block = {
    block = block,
    text = block.text,
    file = block.attr.attributes.file,
    ref = block.attr.attributes.ref
  }
  table.insert(code_blocks, this_block)
  quarto.log.output(code_blocks);
end

function Pandoc(doc)
  local files = {}
  for _, block in ipairs(code_blocks) do
    if block.file then
      this_file = {path = block.file, text = block.text}
      table.insert(files, this_file)
    end

    -- if string.find(block.text, "<<<") then
    --   print(block.text)
    --   print("-------------------------")
    --   local start_marker = "<<<"
    --   local end_marker = ">>>"
  
    --   local start_index, end_index = string.find(block.text, start_marker)
    --   if start_index and end_index then
    --     ref_name = string.sub(block.text, end_index + 1, string.find(block.text, end_marker, end_index + 1) - 1)
    --     print(ref_name)
    --   end
    -- end
  end
  quarto.log.output(files)

  for _, file in ipairs(files) do
    local file_to = io.open(file.path, "w")
    file_to:write(file.text)
    file_to:close()
  end
end
