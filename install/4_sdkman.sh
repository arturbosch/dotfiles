#!/bin/bash
curl -s "https://get.sdkman.io" | bash
. ${SDKMAN_DIR}/bin/sdkman-init.sh
sdk i java
sdk i gradle
sdk i maven
sdk i groovy
