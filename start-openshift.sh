#!/bin/bash

OC_USER=$(istiooc whoami)

if [ $? != 0 ] ; then
  echo "You must be logged into openshift to run this script."
  echo "try 'oc login -u developer'"
  exit 1
fi

echo "Logged in as ${OC_USER}."
istiooc project

echo "Building routing client service"
cd routing-client
npm install
echo "Deploying routing client service"
npm run openshift

cd ../routing-service-a
echo "Building routing service a"
npm install
echo "Deploying routing service a"
npm run openshift

cd ../routing-service-b
echo "Building routing service b"
npm install
echo "Deploying routing service b"
npm run openshift

cd ..
open http://$(istiooc get route istio-ingress -o jsonpath='{.spec.host}{"\n"}' -n istio-system)
