# tomcat-cluster-k8s-container

requirement

* buildah

using os

* fedora30

## create container with buildah

create java-container

```
./create_java_container.sh
```

* create tomcat-cluster-container

```
./create_tomcat_cluster_container.sh
```

* create tomcat-cluster-k8s-container

```
./create_tomcat_cluster_k8s_container.sh
```

## push to quay

```
./push_to_quay.sh
```
