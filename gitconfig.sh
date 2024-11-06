#!/bin/bash
## Configures git
key="F775AADED032998CCB3A555431A25E931748A8F9"

gitargs=('--replace-all')
if [[ $2 == "global" ]]; then
  gitargs+=('--global')
fi

## Accepts a second argument for git, for example --global if want to configure git globally on the machine
case "$1" in
"work")
  git config ${gitargs[*]} user.name 'Carlos Colaço'
  git config ${gitargs[*]} user.email "$WORK_EMAIL"
  git config ${gitargs[*]} user.signingkey "${key}"
  ;;
*)
  git config ${gitargs[*]} user.name 'Carlos Colaço'
  git config ${gitargs[*]} user.email coolapso@coolapso.tech
  git config ${gitargs[*]} user.signingkey "${key}"
  ;;
esac
