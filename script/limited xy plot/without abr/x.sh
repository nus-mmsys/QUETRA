
for text in *.eps; do 



export text
export newtext
echo "file: $text"
epstopdf $text


done

