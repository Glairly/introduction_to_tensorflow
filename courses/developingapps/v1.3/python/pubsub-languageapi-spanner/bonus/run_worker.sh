#!/bin/bash

# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "Exporting GCLOUD_PROJECT and GCLOUD_BUCKET and GOOGLE_APPLICATION_CREDENTIALS"
export GCLOUD_PROJECT=$DEVSHELL_PROJECT_ID
export GCLOUD_BUCKET=$DEVSHELL_PROJECT_ID-media
export GOOGLE_APPLICATION_CREDENTIALS=key.json

echo "Switching to virtual environment"
source ~/venvs/developingapps/bin/activate

echo "Starting worker"
python -m quiz.console.worker