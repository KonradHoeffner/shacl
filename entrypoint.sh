#!/bin/bash
shacl=$1
data=$2
log=$(pyshacl -a -s ${shacl} ${data})
violations=$(grep -c 'Constraint Violation' <<< "$log")
# we can't rely on the exit code of pySHACL until a future pySHACL version, see https://github.com/RDFLib/pySHACL/issues/131
# right now, both errors and violations result in exit code 1
#if [[ "$violations" -eq 0 ]]
if [[ "$log" == *"Conforms: True" ]]
then
	echo "RDG graph ${data} fully conforms to SHACL shape ${shacl}"
	exit 0
elif [[ "$violations" -gt 0 ]]
then
	log="${log//$'\n'/'%0A'}"
	echo "::warning ::$log"
	exit 2
else
	echo "::error ::$log"
	exit 1
fi
echo "::set-output name=violations::$violations"
