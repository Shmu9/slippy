#!/bin/dash

# Tests:
# - Command_c (change) actually deletes line, then prints replacement



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


# do not expect any 2s to be printed as c actually deletes the line and prints the replacement separately
cat > "$expected_output" <<EOF
1
1
1
hello
3
3
3
EOF

slippy '2c hello
1,3p;p' > "$actual_output" 2>&1 <<EOF
1
2
3
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test06: change not apparent or does not actually print replacement separately."
    exit 1
fi

echo "Passed test06"