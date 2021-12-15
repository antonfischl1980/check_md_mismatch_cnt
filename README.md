# check_md_mismatch_cnt

## Intro

This is a Nagios/Icinga compatible check plugin for software raid (mdadm).
It reads /sys/block/md*/md/mismatch_cnt and produces warnings if these values exceed a given threshold.
If you are looking for a plugin that checks /proc/mdstat you should take a look at https://github.com/glensc/nagios-plugin-check_raid 

## Installing

copy check_md_mismatch_cnt.sh to your Nagios/Icinga plugin directory (usually /usr/lib64/nagios/plugins/ )
Edit your Nagios/Icinga config accordingly.
For Icinga2 you can copy check_md_mismatch_cnt.conf to your CheckCommand-Definitions (usually /usr/share/icinga2/include/plugins-contrib.d/ ) 

## Usage

Usage: ./check_md_mismatch_cnt.sh [-w &lt;warning&gt;] [-c &lt;critical&gt;] [-o]  
 -w &lt;warning&gt;   Warning threshold for mismatch_cnt (OPTIONAL, default: 1)  
 -c &lt;critical&gt;  Critical threshold for mismatch_cnt (OPTIONAL, default: 1 (always critical, no warning))  
 -o             Indicate that it is OK for there to be no software raid (without this flag UNKNOWN is returned if no software raid is found)  
 -h       Displays this help message  

## Credits
 
https://www.thomas-krenn.com/en/wiki/Mdadm_checkarray_function for inspiration and a starting point
