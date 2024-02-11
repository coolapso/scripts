#!/bin/bash
## Configures git
key="C6D9BD369FCF4966641E3F79AC2D3B898F96BC51"

case "$1" in
"work")
  git config user.name 'Carlos "4s3ti" Colaço'
  git config user.email "$WORK_EMAIL"
  git config user.signingkey "$key"
  ;;
*)
  git config user.name 4s3ti
  git config user.email 4s3ti@4s3ti.net
  git config user.signingkey "$key"
  ;;
esac
