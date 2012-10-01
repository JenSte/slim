#
# Startup for the SLIM 'rpi' board.
#

# recreate the directories that devtmpfs doesn't contain
mkdir -p /dev/input
mkdir -p /dev/pts

mount -a

# Set log level to LOG_INFO (debug messages are not logged)
syslogd -C -l 7

# Because the ethernet chip is connected via USB, it is not always
# ready right after bootup. Wait a few seconds so that it is ready
# when the network package wants to bring it up.
sleep 2
