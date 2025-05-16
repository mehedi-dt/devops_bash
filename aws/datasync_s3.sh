#!/bin/bash

# this script starts multiple aws datasync tasks using their task ids
# it constructs the full arn for each task and starts the execution
# optionally uses an aws cli profile if specified
# ensure aws cli is configured with the necessary permissions

# this script is useful when you manage many datasync tasks via terraform with different source and destination locations,
# and prefer not to use automatic scheduling (cron/eventbridge). instead of setting a schedule for each task,
# you can manually trigger any task by adding its task id below and running this script as needed.

# configurable variables
REGION="us-east-1"
ACCOUNT_ID="123456789012"
PROFILE="terraform-use1"  # leave empty if not using a profile

# list your task names here (the last part of the arn)
TASK_NAMES=(
  "task-11111111111111111"
  "task-21111111111111111"
)

# loop through each task name, build arn, and trigger execution
for TASK_NAME in "${TASK_NAMES[@]}"; do
  TASK_ARN="arn:aws:datasync:${REGION}:${ACCOUNT_ID}:task/${TASK_NAME}"

  echo "starting datasync task: $TASK_ARN"

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
    echo "successfully started: $TASK_ARN"
  else
    echo "failed to start: $TASK_ARN"
  fi

  echo "-----------------------------------"
done