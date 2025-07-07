#!/bin/bash

set -e

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

echo "=== Running Robot Framework AWS Tests ==="

# Change to the tests directory
cd "$(dirname "$0")"

# Check if robot command is available
if ! command -v robot &> /dev/null; then
    echo "Robot Framework is not installed. Installing..."
    pip install robotframework
fi

# Create results directory if it doesn't exist
mkdir -p results

# Run the Robot Framework tests with detailed logging
echo "Executing Robot Framework tests..."
robot \
    --outputdir results \
    --output output.xml \
    --log log.html \
    --report report.html \
    --loglevel DEBUG \
    simple-test/aws_tests.robot

# Check the exit code
if [ $? -eq 0 ]; then
    echo "All tests passed successfully!"
    echo "Results available in:"
    echo "  - HTML Log: tests/results/log.html"
    echo "  - HTML Report: tests/results/report.html"
    echo "  - XML Output: tests/results/output.xml"
else
    echo "Some tests failed. Check the results in tests/results/ directory"
    exit 1
fi