#!/bin/dash

# Tests:
# - Inplace and quiet modification of file
# - Correct script file parsing:
#   - multiple commands separated by newlines or semicolons
#   - semicolons and commas appearing in regex




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


# create script file
echo '/1,;/,  3d; 4a hello
 p  ; 5    ,   /;,6/  p' > script

# create file
echo '1,;' > file.txt
echo '
2
3
4
5
;,6 match
7
end
' >> file.txt

# modify file quietly
slippy -n -i -f script file.txt

# get modified file contents
cat file.txt > "$actual_output"

cat > "$expected_output" <<EOF
3
hello
4
4
5
5
;,6 match
;,6 match
7
end

EOF

if ! diff "$expected_output" "$actual_output"; then
    echo "Failed test08: file modified incorrectly."
    exit 1
fi

echo "Passed test08"