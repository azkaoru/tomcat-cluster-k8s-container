#!/bin/bash
QUAY_USER=azkaoru
buildah umount fedora30-java-container
buildah rm fedora30-java-container
buildah umount quay.io/${QUAY_USER}/fedora30-java13-devel
buildah rm quay.io/${QUAY_USER}/fedora30-java13-devel

buildah from --name fedora30-java-container fedora:30
buildah run fedora30-java-container /usr/bin/dnf install -y java-openjdk-devel
buildah run fedora30-java-container /usr/bin/dnf clean all
buildah commit fedora30-java-container quay.io/${QUAY_USER}/fedora30-java13-devel
