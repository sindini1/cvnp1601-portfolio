#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 13 evidence report"
echo "Ran: $(date)"
echo
for f in post-incident-report.md week13-diagnosis.md tech-lead-note.md troubleshooting-narrative.md week1-cheatsheet.txt
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
if [ -s ../README.md ]; then echo "FOUND  README.md (repo root)"; else echo "MISSING  README.md (repo root)"; fi
if find . -maxdepth 1 -name 'diagnosis_*.txt' | grep -q .; then
  echo "FOUND  nginx journal capture"
else
  echo "MISSING  nginx journal capture"
fi
if find . -maxdepth 1 -name 'disk_*.txt' | grep -q .; then
  echo "FOUND  disk pressure evidence"
else
  echo "MISSING  disk pressure evidence"
fi
if find . -maxdepth 1 -name 'perm_*.txt' | grep -q .; then
  echo "FOUND  permission evidence"
else
  echo "MISSING  permission evidence"
fi
echo
echo "Done."
} | tee "$report"
