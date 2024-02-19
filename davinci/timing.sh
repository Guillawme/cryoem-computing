#!/usr/bin/env bash

t1=$(date +%s)

# Code doing actual things goes here
sleep 5

t2=$(date +%s)
total_time=$((t2 - t1))
hours=$((total_time / 3600))
minutes=$(( (total_time % 3600) / 60))
seconds=$(( (total_time % 3600) % 60))

echo $total_time
echo "Total time: $hours h $minutes min $seconds s"

