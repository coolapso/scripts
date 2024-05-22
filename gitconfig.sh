#!/bin/bash
## Configures git
key="F775AADED032998CCB3A555431A25E931748A8F9"

case "$1" in
"work")
  git config user.name 'Carlos Colaço'
  git config user.email "$WORK_EMAIL"
  git config user.signingkey "$key"
  ;;
*)
  git config user.name 'Carlos Colaço'
  git config user.email coolapso@coolapso.tech
  git config user.signingkey "$key"
  ;;
esac
