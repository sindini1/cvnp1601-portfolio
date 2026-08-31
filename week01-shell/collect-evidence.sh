#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 1 evidence report"
echo "Ran: $(date)"
echo
for f in week1-cheatsheet.txt errors.txt week1-diagnosis.md tech-lead-note.md troubleshooting-narrative.md CVNP1601-W01-CHECKPOINT04-SHELLMAP CVNP1601-W01-CHECKPOINT07-LOGTRACE
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
if [ -s ../README.md ]; then echo "FOUND  README.md (repo root)"; else echo "MISSING  README.md (repo root)"; fi
if find . -maxdepth 1 -name '*.png' | grep -q .; then
  echo "FOUND  screenshots"
else
  echo "MISSING  screenshots"
fi
echo
echo "Done."
} | tee "$report"
