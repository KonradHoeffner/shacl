#!/bin/sh
echo $shacl
echo $data
log=$(pyshacl -a -s ${shacl} ${data})
echo $log
#violations=$(grep -c 'Constraint Violation' <<< "$log")
#if [[ "$violations" -gt 0 ]]; then echo "::warning ::$log"; fi
#echo $log
#echo "::set-output name=violations::$violations"
