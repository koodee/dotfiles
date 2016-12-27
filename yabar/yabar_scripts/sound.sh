#! /bin/bash

function get_default_sink_id {
    echo $(pacmd list-sinks | grep index: | grep '*' | grep -o '[0-9]\+')
}

function set_default_playback_device_next {
    inc=${1:-1}
    num_devices=$(pacmd list-sinks | grep -c index:)
    sink_arr=($(pacmd list-sinks | grep index: | grep -o '[0-9]\+'))
    default_sink_index=$(( $(pacmd list-sinks | grep index: | grep -no '*' | grep -o '^[0-9]\+') - 1 ))
    default_sink_index=$(( ($default_sink_index + $num_devices + $inc) % $num_devices ))
    default_sink=${sink_arr[$default_sink_index]}
    pacmd set-default-sink $default_sink

    # Move all the sources to the new sink
    source_arr=$(pacmd list-sink-inputs | grep index | grep -o '[0-9]\+')
    for src in $source_arr; do
      pacmd move-sink-input $src $default_sink
    done
}

function print_volume {
for name in INDEX NAME VOL MUTED; do
	read $name
done < <(pacmd list-sinks | grep "index:\|name:\|volume: front\|muted:" | grep -A3 '*')
INDEX=$(echo "$INDEX" | grep -o '[0-9]\+')
VOL=$(echo "$VOL" | grep -o "[0-9]*%" | head -1 )
VOL="${VOL%?}"
NAME=$(echo "$NAME" | sed 's/.*\.\(.*\)>/\1/')

DEVICE=
if [[ "$NAME" =~ ^hdmi.* ]]; then
  DEVICE=
fi

if [[ $MUTED =~ "yes" ]]; then
  echo " $DEVICE"
elif [ $VOL -gt 50 ]; then
  echo " $VOL% $DEVICE"
elif [ $VOL -gt 0 ]; then
  echo " $VOL% $DEVICE"
fi
}

case $@ in
  next) set_default_playback_device_next ;;
  up) amixer -q -D pulse sset Master 5%+ ;;
  down) amixer -q -D pulse sset Master 5%- ;;
  mute) amixer -q -D pulse sset Master toggle ;;
esac

print_volume
