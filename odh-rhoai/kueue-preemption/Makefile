BASE:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SHELL=/bin/sh

.PHONY: teardown-kueue-preemption setup-kueue-preemption

teardown-kueue-preemption:
	
	-oc delete -f $(BASE)/team-a-ray-cluster-prod.yaml -f $(BASE)/team-b-ray-cluster-dev.yaml
	-oc delete -f $(BASE)/team-a-cq.yaml -f $(BASE)/team-b-cq.yaml -f $(BASE)/shared-cq.yaml
	-oc delete -f $(BASE)/team-a-local-queue.yaml -f $(BASE)/team-b-local-queue.yaml	
	-oc delete -f $(BASE)/default-flavor.yaml -f $(BASE)/gpu-flavor.yaml
	-oc delete -f $(BASE)/team-a-rb.yaml -f $(BASE)/team-b-rb.yaml
	-oc delete -f $(BASE)/team-a-ns.yaml -f $(BASE)/team-b-ns.yaml
	
	@echo "Deleting all clusterqueues"
	oc delete clusterqueue --all --all-namespaces 

	@echo "Deleting all resourceflavors"
	oc delete resourceflavor --all --all-namespaces 
	
setup-kueue-preemption:
	
	oc create -f $(BASE)/team-a-ns.yaml -f $(BASE)/team-b-ns.yaml
	oc create -f $(BASE)/team-a-rb.yaml -f $(BASE)/team-b-rb.yaml
	oc create -f $(BASE)/default-flavor.yaml -f $(BASE)/gpu-flavor.yaml
	oc create -f $(BASE)/team-a-cq.yaml -f $(BASE)/team-b-cq.yaml -f $(BASE)/shared-cq.yaml
	oc create -f $(BASE)/team-a-local-queue.yaml -f $(BASE)/team-b-local-queue.yaml