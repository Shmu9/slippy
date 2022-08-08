#!/bin/dash

# Tests:
# - diff between ./slippy and 2041 slippy



# add the current directory to the PATH so scripts
# can still be executed from it after we cd

PATH="$PATH:$(pwd)"

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Create some files to hold output.

expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT


# read from stdin
while read -r line; do
  input="$input\n$line"
done

slippy "$@" > "$actual_output" 2>&1 <<EOF
"$input"
EOF

2041 slippy "$@" > "$expected_output" 2>&1 <<EOF 
"$input"
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Incorrect output"
    exit 1
fi

echo "Correct output"