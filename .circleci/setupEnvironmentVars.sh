#!/bin/bash

set -euo pipefail

INFILE=$1

# get lines with a $, split by : and get the second field (i.e. where yaml value, the env variable name, is)
# and clean it up by stripping whitespace, {, }, and "
VARS=$(grep '\$' $INFILE | cut -d: -f2 | sed -e 's|[\$\{\}\"\s]||g')

# uppercase the environment name and use it as suffix
SUFFIX=${ENVIRONMENT^^}

# set every VAR to the corresponding value in VAR_SUFFIX, echoing to provide feedback in CI
for VAR in $VARS ; do
	echo "export $VAR=${VAR}_${SUFFIX}"
	eval "export $VAR=\${${VAR}_${SUFFIX}}"
done

# replace the values in the INFILE
envsubst < $INFILE
