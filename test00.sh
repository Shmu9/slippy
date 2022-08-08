#!/bin/dash

# Tests:
# - cannot quit on a deleted line
# - number addresses


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


cat > "$expected_output" 2>&1 <<EOF
4
EOF

slippy '1,3d;2q'> "$actual_output" 2>&1 <<EOF
1
2
3
4
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test00"
    exit 1
fi

echo "Passed test00"