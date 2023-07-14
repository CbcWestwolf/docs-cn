#!/bin/bash

set -e
# test passed in pandoc 1.19.1

MAINFONT="WenQuanYi Micro Hei"
MONOFONT="WenQuanYi Micro Hei Mono"

# MAINFONT="Tsentsiu Sans HG"
# MONOFONT="Tsentsiu Sans Console HG"

#_version_tag="$(date '+%Y%m%d').$(git rev-parse --short HEAD)"
_version_tag="$(date '+%Y%m%d')"

# default version: `pandoc --latex-engine=xelatex doc.md -s -o output2.pdf`
# used to debug template setting error

# add docs versions
# generate PDF for dev version

output_path="output.epub"

pandoc -N --toc --pdf-engine=xelatex \
--template=templates/template_epub.tex \
--listings \
--highlight-style=pygments \
-V title="TiDB 中文手册" \
-V author="PingCAP Inc." \
-V date="${_version_tag}" \
-V CJKmainfont="${MAINFONT}" \
-V mainfont="${MAINFONT}" \
-V sansfont="${MAINFONT}" \
-V monofont="${MONOFONT}" \
-V include-after="" \
"doc.md" -s -o "output.epub"
