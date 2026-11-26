#!/bin/bash
report="evidence-report.txt"
{
echo "CVNP1601 Week 14 evidence report"
echo "Ran: $(date)"
echo
for f in docker-run.txt week14-diagnosis.md tech-lead-note.md troubleshooting-narrative.md container-handoff.md README.md
do
  if [ -s "$f" ]; then echo "FOUND  $f"; else echo "MISSING  $f"; fi
done
if [ -s ../README.md ]; then echo "FOUND  README.md (repo root)"; else echo "MISSING  README.md (repo root)"; fi
# Optional live captures (screenshots or text dumps of docker/curl output)
if find . -maxdepth 1 \( -name 'task*.png' -o -name 'task*.txt' -o -name 'docker_*.txt' -o -name 'baseline_*.txt' -o -name 'verify_*.txt' \) | grep -q .; then
  echo "FOUND  at least one live capture (task*/docker_*/baseline_*/verify_*)"
else
  echo "MISSING  live capture screenshots or text dumps (recommended)"
fi
echo
echo "Done."
} | tee "$report"
