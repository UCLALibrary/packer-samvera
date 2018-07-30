#! /bin/bash

#
# A little wrapper Bash script to make building easier.
#

# Override the default action (Cf. `packer -h` for options)
PACKER_ACTION="${PACKER_ACTION:-build}"

if [ "$PACKER_ACTION" == "validate" ]; then
  ON_ERROR=""
else
  ON_ERROR="-on-error=ask"
fi

# Turn on verbose Packer logging by setting: PACKER_LOG=true
PACKER_LOG="${PACKER_LOG:-0}"

# We need to filter the JSON because Packer doesn't support tagged/conditional post-processors
FILTER=(jq '.["post-processors"][0] |= map(select(.type != "vagrant-cloud"))' samvera-${1}.json)

# Some conservative/safe build values
DEFAULT_CORE_COUNT=2
DEFAULT_MEMORY=2048

# Optionally, make our builds speedier by giving them full access to the host's resources
if [ "$3" == "fast" ] || [ "$2" == "fast" ]; then
  if hash getconf 2>/dev/null; then
    if hash free 2>/dev/null; then
      VB_MEMORY=$(free -m | awk '/^Mem:/{print $7}')
      VB_CPU_CORES=$(getconf _NPROCESSORS_ONLN)

      if [ $? -ne 0 ]; then
        VB_CPU_CORES=${DEFAULT_CORE_COUNT}
        VB_MEMORY=${DEFAULT_MEMORY}
      fi
    else
      VB_CPU_CORES=${DEFAULT_CORE_COUNT}
      VB_MEMORY=${DEFAULT_MEMORY}
    fi
  else
    VB_CPU_CORES=${DEFAULT_CORE_COUNT}
    VB_MEMORY=${DEFAULT_MEMORY}
  fi
else
  VB_CPU_CORES=${DEFAULT_CORE_COUNT}
  VB_MEMORY=${DEFAULT_MEMORY}
fi

# Give option to override these in command line (in addition to the config file)
VB_CPU_CORES="${CORES:-$VB_CPU_CORES}"
VB_MEMORY="${MEMORY:-$VB_MEMORY}"

# Provide a usage statement
function printUsage() {
  echo 'Usage: ./build.sh [artifact] [output]'
  echo 'Examples:'
  echo '  ./build.sh base ami'
  echo '  ./build.sh hyrax ami'
  echo '  ./build.sh base box'
  echo '  ./build.sh hyrax box'
#  echo '  ./build.sh base image'
#  echo '  ./build.sh hyrax image'

  exit 1
}

# Confirm that jq is installed on the system
hash jq 2>/dev/null || {
  echo >&2 "jq must be installed to run this script: https://stedolan.github.io/jq/download/"
  exit 1
}

if [ -z "$1" ]; then
  printUsage
elif [ "$2" == "ami" ] || [ "$2" == "box" ]; then
  if [ "$1" == "base" ] || [ "$1" == "hyrax" ]; then
     TMPFILE=$(mktemp)
     "${FILTER[@]}" > $TMPFILE
     PACKER_LOG="$PACKER_LOG" packer "$PACKER_ACTION" -only="$2" -var-file="config.json" $ON_ERROR \
       -var="vb_memory=$VB_MEMORY" -var="vb_cpu_cores=$VB_CPU_CORES" $TMPFILE
  else
    printUsage
  fi
elif [ "$2" == "fast" ] || [ -z "$2" ]; then
  if [ "$1" == "base" ] || [ "$1" == "hyrax" ]; then
     TMPFILE=$(mktemp)
     "${FILTER[@]}" > $TMPFILE
     PACKER_LOG="$PACKER_LOG" packer "$PACKER_ACTION" -var-file="config.json" $ON_ERROR \
       -var="vb_memory=$VB_MEMORY" -var="vb_cpu_cores=$VB_CPU_CORES" $TMPFILE
  else
    printUsage
  fi
else
  printUsage
fi
