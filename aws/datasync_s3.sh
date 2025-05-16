#!/bin/bash

# Configurable variables
REGION="us-east-1"
ACCOUNT_ID="123456789012"
PROFILE="terraform-use1"  # leave empty [""] if not using a profile

# List your task names here (the last part of the ARN)
TASK_NAMES=(
  "task-11111111111111111"
  "task-21111111111111111"
)

# Loop through each task name, build ARN, and trigger execution
for TASK_NAME in "${TASK_NAMES[@]}"; do
  TASK_ARN="arn:aws:datasync:${REGION}:${ACCOUNT_ID}:task/${TASK_NAME}"

  echo "Starting DataSync task: $TASK_ARN"

  if [[ -n "$PROFILE" ]]; then
    aws datasync start-task-execution \
      --task-arn "$TASK_ARN" \
      --region "$REGION" \
      --profile "$PROFILE"
  else
    aws datasync start-task-execution \
      --task-arn "$TASK_ARN" \
      --region "$REGION"
  fi

  if [ $? -eq 0 ]; then
    echo "Successfully started: $TASK_ARN"
  else
    echo "Failed to start: $TASK_ARN"
  fi

  echo "-----------------------------------"
done