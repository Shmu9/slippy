#!/bin/dash

# Tests:
# - Command_a and Command_i are queuable
# - aci commands separated by newlines
# - Multiple commands


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


# expect 1 messaged inserted before second line; 2 appended after

cat > "$expected_output" <<EOF
1
au revoir
2
hello
goodbye
3
bonjour
4
EOF

slippy '2a hello
2a goodbye
2i au revoir
3a bonjour' > "$actual_output" 2>&1 <<EOF
1
2
3
4
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test03: append and insert commands not queued properly."
    exit 1
fi

echo "Passed test03"