#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 4 evidence report"
echo "Ran: $(date)"
echo
for f in permission-audit.txt permission-breakdown.md access-lockdown-summary.md tech-lead-note.md troubleshooting-narrative.md week4-diagnosis.md week4-cheatsheet.txt
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
for f in CVNP1601-W04-CHECKPOINT04-PERMBITS CVNP1601-W04-CHECKPOINT07-ACLCONFIG
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
