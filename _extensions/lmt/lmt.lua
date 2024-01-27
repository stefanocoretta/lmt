code_blocks = {}

function CodeBlock (block)
  local this_block = {
    block = block,
    text = block.text,
    file = block.attr.attributes.file,
    ref = block.attr.attributes.ref
  }
  table.insert(code_blocks, this_block)
  -- quarto.log.output(code_blocks);
end

-- From https://stackoverflow.com/a/69651531/2804314
function key_of(tbl, value)
  for k, v in pairs(tbl) do
      if v.ref == value then
          return k
      end
  end
  return nil
end

function Pandoc(doc)
  local files = {}
  for _, block in ipairs(code_blocks) do
    if block.file then
      -- For now this works only with one referenced block...
      if string.find(block.text, "<<<") then
        local start_marker = "<<<"
        local end_marker = ">>>"
    
        local start_index, end_index = string.find(block.text, start_marker)
        if start_index and end_index then
          ref_name = string.sub(block.text, end_index + 1, string.find(block.text, end_marker, end_index + 1) - 1)
        end
        ref_id = key_of(code_blocks, ref_name)
        print(code_blocks[ref_id].text)

        new_text = string.gsub(
          block.text,
          start_marker .. ref_name .. end_marker,
          code_blocks[ref_id].text
        )
      end
      this_file = {path = block.file, text = new_text}
      table.insert(files, this_file)
    end
  end

  for _, file in ipairs(files) do
    local file_to = io.open(file.path, "w")
    file_to:write(file.text)
    file_to:close()
  end
end
