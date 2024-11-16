#!/bin/bash

# Function to display total CPU usage
function cpu_usage() {
    echo "== CPU Usage =="
    top -l 1 | grep "CPU usage" | awk '{print "CPU Usage: " $3 + $5}'
}

# Function to display memory usage
function memory_usage() {
    echo "== Memory Usage =="
    vm_stat | awk '
    BEGIN {
        printf "Total Memory Usage:\n";
    }
    /free/ { free_pages=$3 }
    /Pages active:/ { active_pages=$3 }
    /Pages inactive:/ { inactive_pages=$3 }
    /Pages speculative:/ { speculative_pages=$3 }
    /Pages wired down:/ { wired_pages=$3 }
    END {
        page_size = 4096; # macOS page size in bytes
        total_memory = (active_pages + inactive_pages + speculative_pages + wired_pages + free_pages) * page_size / 1024 / 1024;
        used_memory = (active_pages + inactive_pages + speculative_pages + wired_pages) * page_size / 1024 / 1024;
        free_memory = free_pages * page_size / 1024 / 1024;
        printf("Used: %.2f MB, Free: %.2f MB, Usage: %.2f%%\n", used_memory, free_memory, (used_memory / total_memory) * 100);
    }'
}

# Function to display disk usage
function disk_usage() {
    echo "== Disk Usage =="
    df -h / | awk '/\// {
        printf("Used: %s, Free: %s, Usage: %s\n", $3, $4, $5)
    }'
}

# Function to display top 5 processes by CPU usage
function top_cpu_processes() {
    echo "== Top 5 Processes by CPU Usage =="
    ps -Ao pid,comm,%cpu --sort=-%cpu | head -n 6
}

# Function to display top 5 processes by memory usage
function top_memory_processes() {
    echo "== Top 5 Processes by Memory Usage =="
    ps -Ao pid,comm,%mem --sort=-%mem | head -n 6
}

# Optional: OS version, uptime, load average, logged-in users
function extra_info() {
    echo "== Extra System Info =="
    echo "OS Version: $(sw_vers -productName) $(sw_vers -productVersion)"
    echo "Uptime: $(uptime | awk -F', ' '{print $1}' | sed 's/^.*up //')"
    echo "Load Average: $(uptime | awk -F'load averages: ' '{print $2}')"
    echo "Logged in Users: $(who | wc -l)"
    echo "Failed Login Attempts: Not available on macOS"
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
