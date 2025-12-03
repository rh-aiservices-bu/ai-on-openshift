#!/bin/sh

echo "Deleting all rayclusters"
oc delete raycluster --all --all-namespaces > /dev/null

echo "Deleting all localqueue"
oc delete localqueue --all --all-namespaces > /dev/null

echo "Deleting all clusterqueues"
oc delete clusterqueue --all --all-namespaces > /dev/null

echo "Deleting all resourceflavors"
oc delete resourceflavor --all --all-namespaces > /dev/null