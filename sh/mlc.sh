#!/bin/bash

has_error=0

for file in $(find ../md -name "*.md"); do
    markdown-link-check $file --config ../mlc_config.json | tee -a mlc_report.txt
    status=${PIPESTATUS[0]}
    if [ $status -eq 0 ]; then
        echo "  Passed!"
    else
        has_error=1
        echo "  Failed!"
    fi
done

grep -v '\[✓\]\|\[/\]\|links checked\|No hyperlinks found' mlc_report.txt > input.txt

while IFS= read -r line; do
    if [[ $line =~ .*#.*%.* ]]; then
        encoded_part=$(echo "$line" | sed -n 's/.*\(#.*%\)/\1/p')
        decoded_part=$(echo $encoded_part | nkf -w --url-input)
        echo "$line" | sed "s/$encoded_part/$decoded_part/"
    else
        echo "$line"
    fi
done < input.txt > output.txt

if [ $has_error -ne 0 ]; then
    echo -e "\e[31mNG list\e[0m"
    while IFS= read -r line; do
        if [[ $line == FILE:* ]]; then
            print_file=0
            current_file="$line"
        elif [[ $line == *[✖]* ]]; then
            if [[ $print_file -eq 0 ]]; then
                echo "$current_file"
                print_file=1
            fi
            echo "$line"
        fi
    done < output.txt
fi

exit $has_error
