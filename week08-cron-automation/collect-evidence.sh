#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 8 evidence report"
echo "Ran: $(date)"
echo
for f in disk_report.sh cron-troubleshooting-note.md week8-diagnosis.md tech-lead-note.md troubleshooting-narrative.md README.md week1-cheatsheet.txt absolute-paths-explanation.md
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
