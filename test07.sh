#!/bin/dash

# Tests:
# - Command_a and Command_i (append/insert) only prints argument, it does not modifiy line
# - Deleted line cannot be printed
# - Deleted line cannot be appended to/inserted upon



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

# do not expect extra prints before 3 as the lines have been deleted and hence do not 
# exist to be copied/print/inserted upon/appended to
cat > "$expected_output" <<EOF
3
3
EOF

slippy '1,2d; 2a hello
2i hello
p' > "$actual_output" 2>&1 <<EOF
1
2
3
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test07: cannot print or act on deleted line."
    exit 1
fi

echo "Passed test07"