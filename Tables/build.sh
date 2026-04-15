#!/bin/bash
# Build a LaTeX table and export it as a high-resolution PNG
# Usage: ./build.sh table5        (compiles table5.tex -> ../Figures/table5.png)
#        ./build.sh table5 600    (custom DPI, default 600)

set -e

NAME="${1:-table5}"
DPI="${2:-600}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FIGURES_DIR="$SCRIPT_DIR/../Figures"

cd "$SCRIPT_DIR"

echo "Compiling $NAME.tex ..."
pdflatex -interaction=nonstopmode "$NAME.tex" > /dev/null 2>&1

echo "Rasterising to PNG at ${DPI} DPI ..."
gs -dNOPAUSE -dBATCH -dSAFER \
   -sDEVICE=png16m \
   -r"$DPI" \
   -dTextAlphaBits=4 -dGraphicsAlphaBits=4 \
   -sOutputFile="$FIGURES_DIR/$NAME.png" \
   "$NAME.pdf" > /dev/null 2>&1

echo "Done → $FIGURES_DIR/$NAME.png"

# Clean auxiliary files
rm -f "$NAME.aux" "$NAME.log"
