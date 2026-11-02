#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 10 evidence report"
echo "Ran: $(date)"
echo
for f in week1-cheatsheet.txt week10-diagnosis.md tech-lead-note.md troubleshooting-narrative.md
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
if [ -s ../README.md ]; then echo "FOUND  README.md (repo root)"; else echo "MISSING  README.md (repo root)"; fi
if find . -maxdepth 1 -name 'network_*.txt' ! -name 'network_postfix_*' | grep -q .; then
  echo "FOUND  pre-change capture"
else
  echo "MISSING  pre-change capture"
fi
if find . -maxdepth 1 -name 'network_postfix_*.txt' | grep -q .; then
  echo "FOUND  post-fix capture"
else
  echo "MISSING  post-fix capture"
fi
if find . -maxdepth 1 \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) | grep -q .; then
  echo "FOUND  screenshots"
else
  echo "MISSING  screenshots"
fi
echo
echo "Done."
} | tee "$report"
