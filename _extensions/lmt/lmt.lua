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
      if string.find(block.text, "<<<") then
    
        local ref_array = {}
        local startPos, endPos = block.text:find("<<<.->>>")
        while startPos do
            local extracted = block.text:sub(startPos + 3, endPos - 3)
            table.insert(ref_array, extracted)
            startPos, endPos = block.text:find("<<<.->>>", endPos + 1)
        end
  
        new_text = block.text
        quarto.log.output(new_text)
        for _, ref in ipairs(ref_array) do
          quarto.log.output(ref)
          ref_id = key_of(code_blocks, ref)
          new_text = string.gsub(
            new_text,
            "<<<" .. ref .. ">>>",
            code_blocks[ref_id].text
          )
        end
      else
        new_text = block.text
      end
      this_file = {path = block.file, text = new_text}
      table.insert(files, this_file)
    end
  end

-- quarto.log.output(files)

  for _, file in ipairs(files) do
    local file_to = io.open(file.path, "w")
    file_to:write(file.text)
    file_to:close()
  end
end
