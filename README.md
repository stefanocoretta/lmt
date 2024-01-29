# Literate Markdown Tangler Extension For Quarto

This ports the functionality of the [Literate Markdown Tangler](https://github.com/driusan/lmt) written in Go by Dave MacFarlane to a Pandoc Lua filter. However, the syntax differs from the Go lmt to comply with Pandoc's markdown.

## Installing

```bash
quarto add stefanocoretta/lmt
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

