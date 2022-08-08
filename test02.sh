#!/bin/dash

# Tests:
# - aci commands print after/as replacement/before repectively
# - aci commands cannot have comments
# - aci arguments with special characters and escapes (currently failing)


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

passed=true

# expect entirety of string from first non-whitespace character to be appended
cat > "$expected_output" <<EOF
a
bruh # hello   # comment\n2p
EOF

slippy '1a bruh \# hello   # comment\\n2p' > "$actual_output" 2>&1 <<EOF
a
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test02a: append command cannot have comments."
    passed=false
fi

# expect entirety of string from first non-whitespace character to be used
cat > "$expected_output" <<EOF
bruh # hello   # comment\n2p
EOF

slippy '1c bruh \# hello   # comment\\n2p' > "$actual_output" 2>&1 <<EOF
a
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test02b: change command cannot have comments."
    passed=false
fi

# expect entirety of string from first non-whitespace character to be inserted
cat > "$expected_output" <<EOF
bruh # hello   # comment
2p
a
EOF

slippy '1i bruh \# hello   # comment\n2p' > "$actual_output" 2>&1 <<EOF
a
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test02c: insert command cannot have comments."
    passed=false
fi

if [ $passed = true ]; then
    echo "Passed test02"
    exit 0
fi

echo "Failed test02"
exit 1