#!/bin/bash
echo '--- Hardware ---' > $(dirname $(realpath $0))/task4_1.out
dmidecode -s processor-version |head -n1 |sed 's/^/CPU: /' >> $(dirname $(realpath $0))/task4_1.out
cat /proc/meminfo |grep MemTotal |awk -F : '{ print $2 }' |sed 's/^[ \t]*//;s/^/RAM: /' >> $(dirname $(realpath $0))/task4_1.out

x=`dmidecode -t baseboard |grep "Product Name" |awk -F : '{print $2}' |sed 's/^[ \t]*//'`
if [ -z "$x" ]; then
echo "Motherboard: Unknown"

else
echo  "Motherboard: $x" >> $(dirname $(realpath $0))/task4_1.out
fi

x=`dmidecode -t baseboard |grep "Serial Number" |awk -F : '{print $2}' |sed 's/^[ \t]*//'`
if [ -z "$x" ]; then
echo "System Serial Number: Unknown"

else
echo  "System Serial Number: $x" >> $(dirname $(realpath $0))/task4_1.out
fi

#dmidecode -t baseboard |grep 'Product Name' |awk -F : '{print $2}' |sed 's/^[ \t]*//;s/^/Motherboard: /' >> $(dirname $(realpath $0))/task4_1.out
#dmidecode -t baseboard |grep 'Serial Number' |awk -F : '{print $2}' |sed 's/^[ \t]*//;s/^/System Serial Number: /' >> $(dirname $(realpath $0))/task4_1.out
echo '--- System ---' >>  $(dirname $(realpath $0))/task4_1.out
lsb_release -a |grep Description |awk -F : '{print $2 }' |sed 's/^[ \t]*//;s/^/OS Distribution: /' >> $(dirname $(realpath $0))/task4_1.out
uname -r |sed 's/^/Kernel version: /' >> $(dirname $(realpath $0))/task4_1.out
find /var/log/installer -maxdepth 0 -printf '%Tm/%Td/%TY\n' |sed 's/^/OS Installation date: /' >> $(dirname $(realpath $0))/task4_1.out
echo $HOSTNAME |sed 's/^/Hostname: /' >> $(dirname $(realpath $0))/task4_1.out 
#uptime | awk -F'( |,|:)+' '{
#    if ($7=="min")
#        m=$6;
#    else {
#        if ($7~/^day/) { d=$6; h=$8; m=$9}
#        else {h=$6;m=$7}
#        }
#    }
#    {
#        print d+0,"days,",h+0,"hours,",m+0,"minutes."
#    }'|sed 's/^/Uptime: /' >> $(dirname $(realpath $0))/task4_1.out

#uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}' |sed 's/^/Uptime: /' >> $(dirname $(realpath $0))/task4_1.out
uptime -p |awk -F up '{print $2}' |sed 's/^[ \t]*//;s/^/Uptime: /' >> $(dirname $(realpath $0))/task4_1.out
ps -A --no-headers |wc -l |sed 's/^/Processes running: /' >> $(dirname $(realpath $0))/task4_1.out
who -u |awk '{print $1}' |wc -l |sed 's/^/User logged in: /' >> $(dirname $(realpath $0))/task4_1.out
echo '--- Network ---' >> $(dirname $(realpath $0))/task4_1.out
for x in `ifconfig -a | grep Link | awk '{print $1}' | sort | egrep -v 'inet6'`
do
if [ -z `ip -4 addr show $x |grep inet |awk '{print $2}'` ]; then
echo "$x: -" >> $(dirname $(realpath $0))/task4_1.out
else
x1=`ip -4 addr show $x |grep inet |awk '{print $2}'`
echo "$x: $x1" >> $(dirname $(realpath $0))/task4_1.out
fi
done
