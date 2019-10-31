#!/bin/bash
QUAY_USER=azkaoru
QUAY_PASS=
TOMCAT_VERSION=9.0.27
podman login -u ${QUAY_USER} -p ${QUAY_PASS} quay.io

podman push --creds ${QUAY_USER}:${QUAY_PASS} quay.io/$QUAY_USER/fedora30-java13-devel
podman push --creds ${QUAY_USER}:${QUAY_PASS} quay.io/$QUAY_USER/tomcat$TOMCAT_VERSION-java13
podman push --creds ${QUAY_USER}:${QUAY_PASS} quay.io/$QUAY_USER/tomcat$TOMCAT_VERSION-cluster-java13
