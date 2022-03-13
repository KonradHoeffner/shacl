#!/bin/bash
shacl=$1
data=$2
IFS=$'\n'
violations_total=0
count=0
while IFS= read -r d
do
	[ -z "$d" ] && continue # skip empty lines
	log=$(pyshacl -a -s ${shacl} ${d})
	violations=$(grep -c 'Constraint Violation' <<< "$log")
	# we can't rely on the exit code of pySHACL until a future pySHACL version, see https://github.com/RDFLib/pySHACL/issues/131
	# right now, both errors and violations result in exit code 1
	#if [[ "$violations" -eq 0 ]]
	if [[ "$log" == *"Conforms: True" ]]
	then
		echo "::notice ::${d} conforms to ${shacl}"
	elif [[ "$violations" -gt 0 ]]
	then
		log="${log//$'\n'/'%0A'}"
		echo "::warning ::${violations} violations in ${d}: $log"
		((violations_total+=violations))
		((count++))
	else
		echo "::error ::$log"
		exit 1
	fi
done <<< "$data"
echo "::set-output name=violations::$violations_total"

if [[ "$violations_total" -eq 0 ]]
then
	exit 0
else
	if [[ "$count" -gt 0 ]]
	then
		echo "::warning ::$violations_total violations in total"
	fi
	exit 2
fi
