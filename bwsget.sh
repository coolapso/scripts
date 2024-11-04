#!/bin/bash
bws secret get "$1" | jq -r '.value'
