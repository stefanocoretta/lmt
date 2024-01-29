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

function find_line_start(str, char_pos)
  local line_start = char_pos
  local current_pos = char_pos - 1

  while current_pos <= char_pos do

      if string.sub(str, current_pos, current_pos) == "\n" then
        line_start = current_pos + 1
        break
      end

      current_pos = current_pos - 1
  end

  return line_start
end

function embed_ref (text, code_blocks)
  if string.find(text, "<<<") then
      
    local ref_array = {}
    local start_pos, end_pos = text:find("<<<.->>>")
    while start_pos do
        local extracted = text:sub(start_pos + 3, end_pos - 3)

        line_start = find_line_start(text, start_pos)
        if line_start < start_pos then
          indent = text:sub(line_start, start_pos - 1)
        else
          indent = ""
        end

        table.insert(ref_array, {extracted = extracted, indent = indent})
        
        start_pos, end_pos = text:find("<<<.->>>", end_pos + 1)
    end

    for _, ref in ipairs(ref_array) do
      local ref_id = key_of(code_blocks, ref.extracted)
      to_replace = code_blocks[ref_id].text
      to_replace = string.gsub(
        to_replace,
        "\n",
        "\n" .. ref.indent
      )
      text = string.gsub(
        text,
        "<<<" .. ref.extracted .. ">>>",
        to_replace
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
