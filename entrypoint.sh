#!/bin/bash
shacl=$1
data=$2
log=$(pyshacl -a -s ${shacl} ${data})
violations=$(grep -c 'Constraint Violation' <<< "$log")
if [[ "$violations" -eq 0 ]]
then
	echo "RDG graph ${data} fully conforms to SHACL shape ${shacl}"
else
	log="${log//$'\n'/'%0A'}"
	echo "::warning ::$log"
fi
echo "::set-output name=violations::$violations"
