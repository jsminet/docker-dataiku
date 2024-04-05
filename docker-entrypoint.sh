#!/bin/bash
# echo commands to the terminal output
set -ex
#export DSS_PORT=${DSS_PORT:-10000}

echo "+ Run installation"

if [ ! -f $DSS_DATADIR/bin/env-default.sh ]; then
	# Initialize new data directory
	$DSS_INSTALLDIR/installer.sh -d $DSS_DATADIR -p $DSS_PORT
	$DSS_DATADIR/bin/dssadmin install-R-integration
	$DSS_DATADIR/bin/dssadmin install-graphics-export
	echo dku.registration.channel=docker-image >> $DSS_DATADIR/config/dip.properties
	echo dku.exports.chrome.sandbox=false >> $DSS_DATADIR/config/dip.properties

elif [ $(bash -c 'source $DSS_DATADIR/bin/env-default.sh && echo $DKUINSTALLDIR') != $DSS_INSTALLDIR ]; then
	# Upgrade existing data directory
	$DSS_INSTALLDIR/installer.sh -d $DSS_DATADIR -u -y
	$DSS_DATADIR/bin/dssadmin install-R-integration
	$DSS_DATADIR/bin/dssadmin install-graphics-export
fi

DAITAIKU_CMD="$1"
case "$DAITAIKU_CMD" in
  run)
  shift 1
    CMD=(
      $DSS_DATADIR/bin/dss run \
          "$@"
    )
    ;;
  *)
    echo "Unknown command: $DAITAIKU_CMD" 1>&2
    exit 1
esac

# Execute the container CMD under tini for better hygiene
exec tini -s -- "${CMD[@]}"