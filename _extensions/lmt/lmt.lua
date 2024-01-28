code_blocks = {}

function CodeBlock (block)
  local this_block = {
    block = block,
    text = block.text,
    file = block.attr.attributes.file,
    ref = block.attr.attributes.ref
  }
  table.insert(code_blocks, this_block)
end

function embed_ref (text, code_blocks)
  if string.find(text, "<<<") then
      
    local ref_array = {}
    local startPos, endPos = text:find("<<<.->>>")
    while startPos do
        local extracted = text:sub(startPos + 3, endPos - 3)
        table.insert(ref_array, extracted)
        startPos, endPos = text:find("<<<.->>>", endPos + 1)
    end

    for _, ref in ipairs(ref_array) do
      ref_id = key_of(code_blocks, ref)
      text = string.gsub(
        text,
        "<<<" .. ref .. ">>>",
        code_blocks[ref_id].text
      )
    end
  else
    text = text
  end
  
  return text
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

function check_ref (text)
  local _, count = string.gsub(new_text, "<<<", "")
  return count
end

function Pandoc(doc)
  local files = {}
  for _, block in ipairs(code_blocks) do
    if block.file then
      new_text = block.text
      local _, count = string.gsub(new_text, "<<<", "")
      -- quarto.log.output(count)
      while check_ref(new_text) > 0 do
        new_text = embed_ref(new_text, code_blocks)
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
