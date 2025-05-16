#!/bin/bash

# this script syncs multiple s3 bucket pairs between different regions
# it uses aws cli and jq to perform sync and verify object count and size
# source buckets are in ap-southeast-1 and destination buckets are in ap-south-1
# you must configure the aws profile beforehand or attach proper iam role

# define aws cli profile
AWS_PROFILE="terraform-apse1"

# define bucket pairs and regions
SOURCE_BUCKETS=("src-bucket-1" "src-bucket-2" "src-bucket-3")
DEST_BUCKETS=("dest-bucket-1" "dest-bucket-2" "dest-bucket-3")
SRC_REGION="ap-southeast-1"
DEST_REGION="ap-south-1"

# function to get object count and total size of a bucket
get_bucket_stats() {
  local BUCKET=$1
  local REGION=$2

  aws s3api list-objects-v2 \
    --bucket "$BUCKET" \
    --region "$REGION" \
    --profile "$AWS_PROFILE" \
    --output json \
    --query '[length(Contents), sum(Contents[].Size)]' \
    | jq -r '.[]'
}

# loop through each pair of source and destination buckets
for i in "${!SOURCE_BUCKETS[@]}"; do
  SRC_BUCKET="${SOURCE_BUCKETS[$i]}"
  DST_BUCKET="${DEST_BUCKETS[$i]}"
  
  echo "syncing $SRC_BUCKET → $DST_BUCKET..."

  aws s3 sync "s3://$SRC_BUCKET" "s3://$DST_BUCKET" \
    --source-region "$SRC_REGION" \
    --region "$DEST_REGION" \
    --exact-timestamps \
    --profile "$AWS_PROFILE"

  if [ $? -eq 0 ]; then
    echo "sync successful: $SRC_BUCKET → $DST_BUCKET"

    echo "verifying object count and total size..."
    SRC_STATS=($(get_bucket_stats "$SRC_BUCKET" "$SRC_REGION"))
    DST_STATS=($(get_bucket_stats "$DST_BUCKET" "$DEST_REGION"))

    SRC_COUNT=${SRC_STATS[0]}
    SRC_SIZE=${SRC_STATS[1]}
    DST_COUNT=${DST_STATS[0]}
    DST_SIZE=${DST_STATS[1]}

    echo "$SRC_BUCKET — objects: $SRC_COUNT, size: $SRC_SIZE bytes"
    echo "$DST_BUCKET — objects: $DST_COUNT, size: $DST_SIZE bytes"

    if [[ "$SRC_COUNT" == "$DST_COUNT" && "$SRC_SIZE" == "$DST_SIZE" ]]; then
      echo "verification passed: object count and size match."
    else
      echo "verification failed: object count or size mismatch."
    fi

  else
    echo "sync failed: $SRC_BUCKET → $DST_BUCKET"
  fi

  echo "------------------------------------------"
done