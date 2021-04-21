!#/bin/bash/

if [ -d "$1" ]; then
  echo "$1:"
  files=$(find -E "$1" -maxdepth 1 -type f -regex '.*(.wav|webm)$')
else
  files="$(ls "$@" | awk '/.wav|.webm$/ { print $0 }')"
fi

for file in $files; do
  temp_file="$(mktemp)"
  base="$(basename "$file")"
  dir="$(dirname "$file")"
  dir=$(basename "$dir")
  echo "${dir}/${base}:"
  ffmpeg -hide_banner -i "$file" -af silencedetect=n=-49dB:d=1.2 -f null - 2> $temp_file
  integrated="$(awk '/silence_end:/ { print $7, $8 }' "$temp_file")"
  ST="$(awk '/silence_end:/ { print $8 }' $temp_file |cut -f1 -d"." | sort -n | tail -1)"

if [ $ST -gt 1 ]; then
 echo "$base" >> ./audioListAsync
else
echo "$base" >> ./audioListOK
fi
rm "$temp_file"
done
