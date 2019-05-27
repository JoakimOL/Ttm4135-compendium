all:
	pandoc --from=markdown+fenced_code_blocks+link_attributes+startnum+raw_tex+fenced_code_attributes+table_captions+pipe_tables -o infosec.pdf --template=eisvogel *.md --highlight-style breezedark
