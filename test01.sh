#!/bin/dash

# Tests:
# - newline in substitute


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

# Test with literal newline
cat > "$expected_output" <<EOF
hello
 goodbye
EOF

slippy 's/a/hello
 goodbye/' > "$actual_output" 2>&1 <<EOF
a
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test01a: wrong output for literal newline in s command."
    passed=false
fi

# Test with '\n'
cat > "$expected_output" <<EOF
sub
/sub
EOF

slippy 's/match/sub\n\/sub/' > "$actual_output" 2>&1 <<EOF
match
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test01b: wrong output for '\n' in s command."
    passed=false
fi

if [ $passed = true ]; then
    echo "Passed test01"
    exit 0
fi

echo "Failed test01"
exit 1