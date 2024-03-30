#!/bin/bash

# Sales terbanyak
sales_terbanyak=$(awk -F ',' 'NR == 1 { next } { if ($17 > tertinggi) { tertinggi = $17; cust = $6 } } END { print cust }' Sandbox.csv)

# Segment dengan profit terkecil
profitMin=$(awk -F ',' 'NR > 1 { segment[$14] += $NF; if (minProfit == "" || segment[$14] < minProfit) { minProfit = segment[$14]; minSegment = $14 } } END { print minSegment }' Sandbox.csv)

# 3 kategori dengan profit terbanyak
top3cat=$(awk -F ',' '{sum[$14] += $20} END { for (Category in sum) { print Category } }' Sandbox.csv | sort -nr | head -n 3)

# Order date dan quantity dari pemesanan Adriaens
adriaens=$(awk -F ',' 'NR==1 { for (i=1; i<=NF; ++i) headers[i] = $i; next } { if ($6 == "Adriaens Grayland") { print headers[2], $2, headers[18], $18 } }' Sandbox.csv)

# Print results
echo "Sales terbanyak: $sales_terbanyak"
echo "Segment dengan profit terkecil: $profitMin"
echo "Top 3 Categories: $top3cat"
echo "Adriaens order date dan quantity:"
echo "$adriaens"
