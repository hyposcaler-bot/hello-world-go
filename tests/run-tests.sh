#!/bin/bash

set -e

echo "=== Running Robot Framework AWS Tests ==="

# Change to the tests directory
cd "$(dirname "$0")"

# Check if robot command is available
if ! command -v robot &> /dev/null; then
    echo "Robot Framework is not installed. Installing..."
    pip install robotframework
fi

# Run the Robot Framework tests
echo "Executing Robot Framework tests..."
robot --outputdir results simple-test/aws_tests.robot

# Check the exit code
if [ $? -eq 0 ]; then
    echo "All tests passed successfully!"
else
    echo "Some tests failed. Check the results in tests/results/ directory"
    exit 1
fi