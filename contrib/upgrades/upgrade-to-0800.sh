#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
. "${SCRIPT_DIR}/../../helpers.sh"
load_env

try mv /etc/profile.d/rdwvcc-env$SCRIPTS_POSTFIX.sh /etc/profile.d/rdwv-env$SCRIPTS_POSTFIX.sh
try mv $HOME/rdwvcc-env$SCRIPTS_POSTFIX.sh $HOME/rdwv-env$SCRIPTS_POSTFIX.sh
try systemctl disable rdwvcc$SCRIPTS_POSTFIX.service
try systemctl stop rdwvcc$SCRIPTS_POSTFIX.service
try mv /etc/systemd/system/rdwvcc$SCRIPTS_POSTFIX.service /etc/systemd/system/rdwv$SCRIPTS_POSTFIX.service
try systemctl daemon-reload
try systemctl enable rdwv$SCRIPTS_POSTFIX.service
try systemctl start rdwv$SCRIPTS_POSTFIX.service
