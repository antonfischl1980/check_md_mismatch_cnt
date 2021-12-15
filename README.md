# check_md_mismatch_cnt
This is a Nagios/Icinga compatible check plugin for software raid (mdadm). It reads /sys/block/md*/md/mismatch_cnt and produces warnings if these values exceed a given threshold.
