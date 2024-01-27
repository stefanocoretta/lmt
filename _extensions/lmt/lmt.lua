code_blocks = {}

function CodeBlock (block)
  -- I might want to save the file and chunk ref for later
  table.insert(code_blocks, block)
  quarto.log.output(code_blocks);
end

function Pandoc(doc)
  for _, block in ipairs(code_blocks) do
    if string.find(block.text, "<<<") then
      print(block.text)
      print("-------------------------")
      local start_marker = "<<<"
      local end_marker = ">>>"
  
      local start_index, end_index = string.find(block.text, start_marker)
      if start_index and end_index then
        ref_name = string.sub(block.text, end_index + 1, string.find(block.text, end_marker, end_index + 1) - 1)
        print(ref_name)

      end
    end  
  end
end

-- function CodeBlock(block)
--   -- quarto.log.output(block)
--   if block.attr.attributes.file then
--     file_name = block.attr.attributes.file
    
--     file_text = block.text
    
--     local file = io.open(file_name, "w")
--     file:write(block.text)
--     file:close()
--   end
-- end
