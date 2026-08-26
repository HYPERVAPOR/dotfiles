#!/usr/bin/env bash
# 简单测试 nvim 启动时间
# 用法：./bench_startup.sh [运行次数]

set -e

RUNS="${1:-5}"
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

echo "Benchmarking nvim startup (${RUNS} runs)..."

TIMES=()
for i in $(seq 1 "$RUNS"); do
  nvim --startuptime "$TMP" -c 'qa!' > /dev/null 2>&1
  total_ms=$(grep -m 1 -- '--- NVIM STARTED ---' "$TMP" | awk '{print $1}')
  echo "Run $i: ${total_ms} ms"
  TIMES+=("$total_ms")
done

echo ""
printf '%s\n' "${TIMES[@]}" | awk '
  { sum += $1; count++ }
  NR == 1 || $1 < min { min = $1 }
  NR == 1 || $1 > max { max = $1 }
  END {
    printf "Result: avg=%.3f ms | min=%.3f ms | max=%.3f ms (%d runs)\n", sum/count, min, max, count
  }
'
