#!/bin/bash
## Disables / enables pihole

case $1 in
"disable")
  curl "https://pihole.colaco.cloud/admin/api.php?disable&auth=${PIHOLE_TOKEN}";;
"enable")
  curl "https://pihole.colaco.cloud/admin/api.php?enable&auth=${PIHOLE_TOKEN}";;
*)
  echo "provide argument: enable, disable";;
esac
