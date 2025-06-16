#!/bin/bash
# Asking the user to enter his/her name

read -p "Enter the same name as entered in the environment folder name: " names
if [ -z "$names" ]; then
        echo "Please enter your name"
        exit 1
fi
if ! [[ "$names" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "The name must not contain numbers"
    exit 1
fi
dir="submission_reminder_$names"
submissions_file="$dir/assets/submissions.txt"

if [ ! -d "$dir" ]; then
        echo "Directory '$dir' not found"
        echo "You have to run create_environment.sh."
        exit 1
fi
read -p "Enter the name for the assignment: " assignments
read -p "Enter the number of days: " periods
assignments=$(echo "$assignments" | sed "s/$(echo -e '\u00a0')/ /g" | tr -cd '[:alnum:] [:space:]' | xargs)

periods=$(echo "$periods" | xargs)

echo "DEBUG: [$assignments]"

# Input validation
if [ -z "$assignments" ] || ! [[ "$periods" =~ ^[0-9]+$ ]]; then
    echo "The Assignment name cannot be empty"
    echo "Days must be in numeric form"
    exit 1
fi

# Checking if the Assignment name ain't numerical
if ! echo "$assignments" | grep -qE '^[A-Za-z ]+$'; then
    echo "The name must not have numbers"
    exit 1
fi
# Checking if the assignment exists in submissions.txt

matched_assignments=$(grep -i ", *$assignments" "$submissions_file" | awk -F',' '{print $2}' | head -n1 | xargs)

if [ -z "$matched_assignments" ]; then
    echo "$assignments isn't in submissions.txt"
    exit 1
fi

echo "Updating config.env in $dir/config/"
echo "Assignment=\"$matched_assignments\"" > "$dir/config/config.env"
echo "Days remaining=$periods" >> "$dir/config/config.env"

echo "Configuration modified:"
cat "$dir/config/config.env"

read -p "Would you like to run the reminder app now? (y/n): " pick

if [[ "$pick" =~ ^[Yy]$ ]]; then
    echo "...Starting the app..."
    bash "$dir/startup.sh"
    echo "Done"
else
    echo "failed"
fi
