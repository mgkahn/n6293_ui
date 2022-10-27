#! /bin/sh

# Install DbSchema from DEB loaded into /usr/local/dbschema during docker build
# If architecture is AARCH64, replace X64 jars for javafx with AARCH64 jars in DBSchema/lib
# aarch64 jars loaded into /usr/local/openjfx/aarch64 during docker build
# Install DBSchema
# Architecture-specific javafx JARS obtained from https://repo1.maven.org/maven2/org/openjfx/

# Install only if dbschema not already installed
dpkg -l | grep -q dbschema || (curl -L -o /builder/dbschema/dbschema.deb -L ${DBSURL} && dpkg -i /builder/dbschema/dbschema.deb)

ARCH=$(uname -m)
case $ARCH in 
 'aarch64')
    rm -fr /opt/DbSchema/lib/javafx*linux.jar
    cp /builder/dbschema/openjfx/aarch64/* /opt/DbSchema/lib
    ;;
*) ;;
esac

 
