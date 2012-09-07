#
# Startup for the SLIM 'rpi' board.
#

# recreate the directories that devtmpfs doesn't contain
mkdir -p /dev/input
mkdir -p /dev/pts

mount -a

# Set log level to LOG_INFO (debug messages are not logged)
syslogd -C -l 7
