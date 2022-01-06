#!/usr/bin/env bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
gcloud beta container clusters create ${C1_NAME} \
    --zone ${C1_ZONE} \
    --machine-type=n1-standard-4 \
    --num-nodes=${C1_NODES} \
    --workload-pool=${WORKLOAD_POOL} \
    --enable-stackdriver-kubernetes \
    --subnetwork=default \
    --labels mesh_id=${MESH_ID} \
    --release-channel "regular"

echo "Registering the gke cluster..."
for (( i=1; i<=4; i++))
do
  res=$(gcloud container hub memberships register ${C1_NAME}-connect --gke-cluster=${C1_ZONE}/${C1_NAME} --enable-workload-identity 2>&1)
  g1=$(echo $res | grep "PERMISSION_DENIED: hub default service account does not have access to the GKE cluster project for")
  g2=$(echo $res | grep -c "PERMISSION_DENIED: hub default service account does not have access to the GKE cluster project for")
  if [[ "$g2" == "0" ]]; then
    echo "Cluster registered!"
    break;
  fi
    echo "Permissions problem, waiting and retrying"
    sleep 60
done

# should add error checking