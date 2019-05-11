#!/bin/bash
set -ev

docker build -t mschregardus/multi-client:latest -t mschregardus/multi-client:$SHA -f ./client/Dockerfile ./client/
docker build -t mschregardus/multi-server:latest -t mschregardus/multi-server:$SHA -f ./server/Dockerfile ./server/
docker build -t mschregardus/multi-worker:latest -t mschregardus/multi-worker:$SHA -f ./worker/Dockerfile ./worker/

docker push mschregardus/multi-client:latest
docker push mschregardus/multi-server:latest
docker push mschregardus/multi-worker:latest

docker push mschregardus/multi-client:$SHA
docker push mschregardus/multi-server:$SHA
docker push mschregardus/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/client-deployment server=mschregardus/multi-client:$SHA
kubectl set image deployments/server-deployment server=mschregardus/multi-server:$SHA
kubectl set image deployments/worker-deployment server=mschregardus/multi-worker:$SHA