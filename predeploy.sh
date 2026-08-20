#!/bin/sh
set -e
/opt/operately/bin/create_db
/opt/operately/bin/migrate
