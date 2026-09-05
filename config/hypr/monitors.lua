
leftMonitor   = "HDMI-A-1"
middleMonitor = "DP-1"
rightMonitor  = "DVI-D-1"

--left
hl.monitor({
	output=leftMonitor,
	position="0x200",
	scale="1",
	mode="1920x1080@60"
})

--middle
hl.monitor({
	output=middleMonitor,
	mode="2560x1440@144",
	scale="1",
	position="1920x0"
})



--right
hl.monitor({
	output=rightMonitor,
	mode="1920x1080@60",
	scale="1",
	position="4480x320"
})
