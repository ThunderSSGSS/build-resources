export SITE_URL="https://thunderssgss.github.io/build-resources"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S')[LOG] - $1"
}

log "Download build script"
curl -O $SITE_URL/build.sh

log "Download deploy script"
curl -O $SITE_URL/deploy.sh

log "Download version script"
curl -O $SITE_URL/version.sh

log "Download push script"
curl -O $SITE_URL/push.sh

log "Download version script"
curl -O $SITE_URL/version.sh
curl -O $SITE_URL/version.py

log "Finished!"