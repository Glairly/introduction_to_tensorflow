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

echo "### "
echo "### Begin provision remote cluster"
echo "### "

gsutil mb $KOPS_STORE

n=0
until [ $n -ge 5 ]
do
    gsutil ls | grep $KOPS_STORE && break
    n=$[$n+1]
    sleep 3
done

export KOPS_FEATURE_FLAGS=AlphaAllowGCE

echo "Create kops cluster..."
kops create cluster \
--name=$C2_FULLNAME \
--zones=$KOPS_ZONES \
--state=$KOPS_STORE \
--project=${PROJECT_ID} \
--node-count=$NODE_COUNT \
--node-size=$NODE_SIZE \
--admin-access=$INSTANCE_CIDR \
--yes

for (( c=1; c<=20; c++))
do
	echo "Check if cluster is ready - Attempt $c"
        CHECK=`kops validate cluster --name $C2_FULLNAME --state $KOPS_STORE | grep ready | wc -l`
        if [[ "$CHECK" == "1" ]]; then
                break;
        fi
        sleep 10
done

sleep 20

kops export kubecfg --name $C2_FULLNAME --state=$KOPS_STORE
gsutil cp ~/.kube/config $KOPS_STORE
export KUBECONFIG=~/.kube/config

# should update to do cluster registration

echo "### "
echo "### Provision remote cluster complete"
echo "### "
echo "Wait for nodes to be ready with:  'watch kubectl get nodes'"