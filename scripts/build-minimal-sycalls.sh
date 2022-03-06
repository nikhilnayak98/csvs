#!/bin/bash
# find minimal syscalls by removing from default syscalls

rm list-of-min-syscalls
while read s
do
  echo "$s  being removed from moby-default.json"
  grep -v "\"${s}\"" ./moby-default.json > tmp.json
  docker run --rm --security-opt seccomp:tmp.json centos:7 true || echo $s >> list-of-min-syscalls

done < ./moby-syscalls


