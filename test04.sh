#!/bin/dash

# Tests:
# - comment only escaped by newline
# - regex addresses + substitution match/substitution
# - substitution modifier g


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

# do not expect extra prints as they are part of comment
cat > "$expected_output" <<EOF
a
match
a1
substitution
asubstitution
a2substitution
match
EOF

slippy '/a1/,/a2/s/match/substitution/g   # comment;1,3p' > "$actual_output" 2>&1 <<EOF
a
match
a1
match
amatch
a2match
match
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test04a: incorrect substitution or excess printing."
    passed=false
fi

# expect extra prints
cat > "$expected_output" <<EOF
1
1
a1 substitution 2 substitution
a1 substitution 2 substitution
a? 1 substitution 2 substitution 3 substitution?
a? 1 substitution 2 substitution 3 substitution?
a2
match
EOF

slippy '/a1/,/a2/s/match/substitution/g   # comment
1,3p' > "$actual_output" 2>&1 <<EOF
1
a1 match 2 match
a? 1 match 2 match 3 match?
a2
match
EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test04b: incorrect substitution or missed prints."
    passed=false
fi


if [ $passed = true ]; then
    echo "Passed test04"
    exit 0
fi

echo "Failed test04"
exit 1