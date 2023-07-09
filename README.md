# Implementation of 'sed -E' in Python
- cmd line parsing
- OO command object factory
- application of command(s) on input stream

## Current Parseable Command Subset:
- ':' 
- 'a'
- 'b'
- 'c'
- 'd'
- 'i'
- 'p'
- 'q'
- 's'
- 't'

**Branching/labelling (':', 'b', 't') currently not implemented. Buggy handling of backslash ( \\ ) escaping in some areas.**

# Usage
`./slippy [-i] [-n] [-f <script-file> | <sed-command>] [<files>...]`
