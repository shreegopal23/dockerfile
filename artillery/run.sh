#!/bin/bash

# Ensure artillery is installed
if ! command -v artillery &> /dev/null; then
    echo "Artillery is not installed. Please install it first."
    exit 1
fi

# Define the Artillery test file
TEST_FILE="check-app-update-purge.yml"

# Check if the test file exists
if [ ! -f "$TEST_FILE" ]; then
    echo "Test file $TEST_FILE does not exist. Please provide the correct path to the test file."
    exit 1
fi

# Get the current date and Unix timestamp
CURRENT_DATE=$(date +%d-%m-%y)
TIMESTAMP=$(date +%s)

# Define the results directory and ensure it exists
RESULT_DIR="result/$CURRENT_DATE"
mkdir -p "$RESULT_DIR"

# Define output files
OUTPUT_FILE="${RESULT_DIR}/raw-report-${TIMESTAMP}.json"
BAD_LOG_FILE="${RESULT_DIR}/bad-responses-${TIMESTAMP}.log"

# Run the Artillery test, capture stdout+stderr, and tee to log file
echo "Running Artillery test..."
artillery run --output "$OUTPUT_FILE" "$TEST_FILE" 2>&1 | tee "$BAD_LOG_FILE"

# Check if the output file was generated
if [ -f "$OUTPUT_FILE" ]; then
    echo "Artillery test completed. Output saved to $OUTPUT_FILE"

    # Generate the report from the output file
    echo "Generating Artillery report..."
    artillery report "$OUTPUT_FILE" --output "${RESULT_DIR}/report-${TIMESTAMP}.html"

    echo "Report generated and saved to ${RESULT_DIR}/report-${TIMESTAMP}.html"
    echo "Bad response logs (if any) saved to ${BAD_LOG_FILE}"
else
    echo "Failed to generate the output file. Please check for errors."
    exit 1
fi

