# Copyright 2017 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Example implementation of code to run on the Cloud ML service.
"""

import traceback
import argparse
import json
import os

from . import model

import tensorflow as tf

if __name__ == "__main__":
  parser = argparse.ArgumentParser()
  # File Arguments
  parser.add_argument(
    "--job-dir",
    help="this model ignores this field, but it is required by gcloud",
    default="junk"
  )
  parser.add_argument(
    "--train_data_paths",
    help="GCS or local path to training data",
    required=True
  )
  parser.add_argument(
    "--eval_data_paths",
    help="GCS or local path to evaluation data",
    required=True
  )
  parser.add_argument(
    "--output_dir",
    help="GCS location to write checkpoints and export models",
    required=True
  )
  # Training arguments
  parser.add_argument(
    "--train_steps",
    help="Steps to run the training job for",
    type=int,
    default=5000
  )
  parser.add_argument(
    "--train_batch_size",
    help="Batch size for training steps",
    type=int,
    default=512
  )
  # Eval arguments
  parser.add_argument(
    "--eval_steps",
    help="Number of steps to run evalution for at each checkpoint",
    type=int,
    default=10
  )
  parser.add_argument(
    "--eval_batch_size",
    help="Batch size for evaluation steps",
    type=int,
    default=512
  )
  # Model arguments
  parser.add_argument(
    "--nbuckets",
    help="Number of buckets into which to discretize lats and lons",
    type=int,
    default=10
  )
  parser.add_argument(
    "--hidden_units",
    help="Hidden layer sizes to use for DNN feature columns, provide comma-separated layers",
    type=str,
    default="128,32,4"
  )

  args = parser.parse_args()
  arguments = args.__dict__

  # Unused args provided by service
  arguments.pop("job_dir", None)
  arguments.pop("job-dir", None)
  
  # Fix hidden units
  arguments["hidden_units"] = [int(x) for x in arguments["hidden_units"].split(",")]

  # Append trial_id to path if we are doing hptuning
  # This code can be removed if you are not using hyperparameter tuning
  arguments["output_dir"] = os.path.join(
    arguments["output_dir"],
    json.loads(
      os.environ.get("TF_CONFIG", "{}")
    ).get("task", {}).get("trial", "")
  ) 

  # Run the training job:
  try:
    model.train_and_evaluate(arguments)
  except:
    traceback.print_exc()