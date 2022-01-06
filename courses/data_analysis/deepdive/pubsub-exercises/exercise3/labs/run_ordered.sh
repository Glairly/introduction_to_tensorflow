#!/bin/bash
set -m
PROJECT=`curl http://metadata.google.internal/computeMetadata/v1/project/project-id -H "Metadata-Flavor: Google"`
SUBSCRIPTION_KEY=`date +"%H%M%S%N"`
SUBSCRIPTION=pubsub-e2e-example-sub-$SUBSCRIPTION_KEY
OLD_SUBSCRIPTION=`cat .last_subscription`
echo "Delete old subscription."
gcloud pubsub subscriptions delete $OLD_SUBSCRIPTION
echo "Create new subscription."
gcloud pubsub subscriptions create --topic pubsub-e2e-example $SUBSCRIPTION --enable-message-ordering
echo $SUBSCRIPTION > .last_subscription
echo "Starting publisher and publishing 1M messages."
java -Xmx1024m -cp target/pubsub.jar com.google.cloud.sme.pubsub.Publisher -p $PROJECT -o
echo "Starting subscriber."
java -Xmx1024m -cp target/pubsub.jar com.google.cloud.sme.pubsub.Subscriber -p $PROJECT --subscription $SUBSCRIPTION -o
