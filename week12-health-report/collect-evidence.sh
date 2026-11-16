#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 12 evidence report"
echo "Ran: $(date)"
echo
for f in health_report.sh week1-cheatsheet.txt week12-diagnosis.md tech-lead-note.md troubleshooting-narrative.md
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
if [ -s ../README.md ]; then echo "FOUND  README.md (repo root)"; else echo "MISSING  README.md (repo root)"; fi
if find . -maxdepth 1 -name 'health_*.log' | grep -q .; then
  echo "FOUND  health report output"
else
  echo "MISSING  health report output"
fi
if find . -maxdepth 1 -name 'crontab*.txt' -o -name 'cron*.txt' | grep -q .; then
  echo "FOUND  cron evidence"
else
  echo "MISSING  cron evidence"
fi
if find . -maxdepth 1 \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) | grep -q .; then
  echo "FOUND  screenshots"
else
  echo "MISSING  screenshots"
fi
echo
echo "Done."
} | tee "$report"
