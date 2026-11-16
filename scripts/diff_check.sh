#!/bin/bash
cd /workspaces/titlecase-go
docker run --rm -v "$PWD/solution/solve.sh:/solve.sh:ro" -v "$PWD/tests:/tests:ro" titlecase-go-env bash -c '
bash /solve.sh >/dev/null && go build -o /tmp/tc_bin . && /tmp/tc_bin < /tests/data/inputs.txt > /tmp/actual.txt
echo "line counts: expected=$(wc -l < /tests/data/expected.txt) actual=$(wc -l < /tmp/actual.txt)"
awk '"'"'FILENAME==ARGV[1]{inp[FNR]=$0;next} FILENAME==ARGV[2]{exp[FNR]=$0;next}
{ if ($0!=exp[FNR]) { n++; if (n<=10) { print "INPUT:    " inp[FNR]; print "EXPECTED: " exp[FNR]; print "ACTUAL:   " $0; print "" } } }
END { print n+0, "lines differ" }'"'"' /tests/data/inputs.txt /tests/data/expected.txt /tmp/actual.txt'
