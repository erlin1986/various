#!/bin/bash


if [ -d "$1" ]; then
  echo "$1:"
  files=$(find -E "$1" -maxdepth 1 -type f -regex '.*(.webm)$')
else
  files="$(ls "$@" | awk '/.webm$/ { print $0 }')"
fi
for file in $files; do
  temp_file="$(mktemp)"
  temp1_file="$(mktemp)"
  base="$(basename "$file")"
  dir="$(dirname "$file")"
  dir=$(basename "$dir")
  #echo "${dir}/${base}:"

  ffprobe -v error -i "$file" -show_entries stream=width,height,bit_rate,duration -of default=noprint_wrappers=1 > $temp_file
  width="$(awk '/width=/ { print $1 }' "$temp_file"| cut -f2 -d"=" )"
  height="$(awk '/height=/ { print $1 }' "$temp_file"| cut -f2 -d"=" )"
  xposition=$((width / 2))
  yposition=$((height * 10/100))

  ffmpeg -hide_banner -i "$file" -vf "select='not(mod(n\,1000))',crop=200:200:$xposition:0,blackframe=98:32" -f null - 2>> $temp_file
  cl_framedetect="$(awk '/pblack:/ { print $5, $6 }' "$temp_file")"

  ffmpeg -hide_banner -i "$file" -vf "select='not(mod(n\,1000))',crop=200:200:100:$yposition,blackframe=98:32" -f null - 2>> $temp1_file
  op_framedetect="$(awk '/pblack:/ { print $5, $6 }' "$temp1_file")"
  clBF="$(awk '/pblack:/ { print $6 }' "$temp_file" |wc -l)"
  clmaxBF="$(awk '/pblack:/ { print $5 }' "$temp_file" |cut -f2 -d":" | sort -n | tail -1)"
  opBF="$(awk '/pblack:/ { print $6 }' "$temp1_file" |wc -l)"
  opmaxBF="$(awk '/pblack:/ { print $5 }' "$temp1_file" |cut -f2 -d":" | sort -n | tail -1)"

if [ -n "$cl_framedetect" ] || [ -n "$op_framedetect" ]; then
  echo "there are black frames on ${dir}/${base}:"
	if [ -n "$cl_framedetect" ] && [ -n "$op_framedetect" ]; then
		echo "${dir}/${base}:  Detected in client $clmaxBF % black screen and total number of extracted frame is $clBF times"
		echo "${dir}/${base}: Detected in operator $opmaxBF % black sceen and total number of extracted black frame is  $opBF "

	else
		if [ -z "$cl_framedetect" ] && [ -n "$op_framedetect" ]; then
		echo "${dir}/${base}: Detected in operator $opmaxBF % black screen  and total number of extracted black frame is  $opBF "
		echo "$base" >> ./videoListBlack

			else
#				if [ -n "$cl_framedetect" ] && [ -z "$op_framedetect" ]; then
                                echo "${dir}/${base}: Detected in client $clmaxBF % black screen and total number of extracted black frame $clBF"
                                echo "$base" >> ./videoListBlack
                                fi

	fi
fi

if [ -z "$cl_framedetect" ] && [ -z "$op_framedetect" ]; then

    echo "No blackframe interval on ${dir}/${base}"
    echo "$base" >> ./VideolistOK
else
echo "Please check the video quality ${dir}/${base}"
fi
rm "$temp_file"
rm "$temp1_file"
done
