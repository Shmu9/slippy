#!/bin/dash

# Tests:
# - forward slash / escapable by backslash \ in address parsing



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

# do not expect double \, expect escaped / and \
cat > "$expected_output" <<EOF
1
/a
/a
2
2
\/b
\/b
3
EOF

slippy '/\/a/,/\\\/b/p' > "$actual_output" 2>&1 <<EOF
1
/a
2
\/b
3
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test05: / not escapable by \."
    exit 1
fi

echo "Passed test05"