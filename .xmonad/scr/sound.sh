default="`pactl get-default-sink`"

if [ "$default" == 'alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo' ]; then
	pacmd set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo
else
	pacmd set-default-sink alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo
fi
