#!/bin/bash

# Function to display total CPU usage
function cpu_usage() {
    echo "== CPU Usage =="
    top -bn1 | grep "Cpu(s)" | \
    awk '{print "CPU Usage: " $2 + $4 "%"}'
}

# Function to display memory usage
function memory_usage() {
    echo "== Memory Usage =="
    free -h | awk '/^Mem:/ {
        printf("Used: %s, Free: %s, Usage: %.2f%%\n", $3, $4, $3/$2*100)
    }'
}

# Function to display disk usage
function disk_usage() {
    echo "== Disk Usage =="
    df -h --total | awk '/^total/ {
        printf("Used: %s, Free: %s, Usage: %s\n", $3, $4, $5)
    }'
}

# Function to display top 5 processes by CPU usage
function top_cpu_processes() {
    echo "== Top 5 Processes by CPU Usage =="
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

# Function to display top 5 processes by memory usage
function top_memory_processes() {
    echo "== Top 5 Processes by Memory Usage =="
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

# Optional: OS version, uptime, load average, logged-in users
function extra_info() {
    echo "== Extra System Info =="
    echo "OS Version: $(lsb_release -d | cut -f2)"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
    echo "Logged in Users: $(who | wc -l)"
    echo "Failed Login Attempts: $(grep 'Failed password' /var/log/auth.log | wc -l)"
}

# Run all functions
cpu_usage
echo
memory_usage
echo
disk_usage
echo
top_cpu_processes
echo
top_memory_processes
echo
extra_info
