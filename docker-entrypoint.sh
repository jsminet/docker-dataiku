#!/bin/bash
# echo commands to the terminal output
set -ex

export PATH=$PATH:${DSS_INSTALLDIR}:${DSS_DATADIR}/bin

echo "+ Run installation"

if [ ! -f $DSS_DATADIR/bin/env-default.sh ]; then
	echo "+ Initialize new data directory"
    installer.sh -d $DSS_DATADIR -p $DSS_PORT
    dssadmin install-R-integration
    dssadmin install-graphics-export
    echo dku.registration.channel=docker-image >> $DSS_DATADIR/config/dip.properties
    echo dku.exports.chrome.sandbox=false >> $DSS_DATADIR/config/dip.properties
elif [ $(bash -c 'source $DSS_DATADIR/bin/env-default.sh && echo $DKUINSTALLDIR') != $DSS_INSTALLDIR ]; then
	echo "+ Upgrade existing data directory"
	  installer.sh -d $DSS_DATADIR -u -y
	  dssadmin install-R-integration
	  dssadmin install-graphics-export
fi

DATAIKU_CMD="$1"
case "$DATAIKU_CMD" in
  run)
  shift 1
    CMD=(
      $DSS_DATADIR/bin/dss run \
          "$@"
    )
    ;;
  *)
    echo "Unknown command: $DATAIKU_CMD" 1>&2
    exit 1
esac

# Execute the container CMD under tini for better hygiene
exec tini -s -- "${CMD[@]}"