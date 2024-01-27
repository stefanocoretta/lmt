function CodeBlock(block)
  -- quarto.log.output(block)
  if block.attr.attributes.file then
    file_name = block.attr.attributes.file
    local file = io.open(file_name, "w")

    file:write(block.text)
    file:close()
  end
end
