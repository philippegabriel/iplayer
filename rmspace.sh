for file in *.mp3; do mv "$file" "${file//[[:space:],&\'#]}" ; done
for file in *.jpg; do mv "$file" "${file//[[:space:],&\'#]}" ; done
for file in *.tag; do mv "$file" "${file//[[:space:],&\'#]}" ; done
