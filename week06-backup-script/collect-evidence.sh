#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 6 evidence report"
echo "Ran: $(date)"
echo
for f in backup_etc.sh week1-cheatsheet.txt week6-diagnosis.md tech-lead-note.md troubleshooting-narrative.md
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
if [ -s ../README.md ]; then echo "FOUND  README.md (repo root)"; else echo "MISSING  README.md (repo root)"; fi
if find . -maxdepth 1 \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) | grep -q .; then
  echo "FOUND  screenshots"
else
  echo "MISSING  screenshots"
fi
echo
echo "Done."
} | tee "$report"
