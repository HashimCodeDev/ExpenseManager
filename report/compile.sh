#!/bin/bash

# Expense Manager LaTeX Report Compilation Script
# This script compiles the LaTeX document and handles bibliography and cross-references

echo "Starting LaTeX compilation for Expense Manager Report..."

# Create output directory if it doesn't exist
mkdir -p output

# First compilation
echo "First compilation pass..."
pdflatex -output-directory=output main.tex

# Second compilation for cross-references
echo "Second compilation pass for cross-references..."
pdflatex -output-directory=output main.tex

# Third compilation to ensure all references are resolved
echo "Final compilation pass..."
pdflatex -output-directory=output main.tex

# Check if compilation was successful
if [ -f "output/main.pdf" ]; then
    echo "✓ Compilation successful! PDF generated: output/main.pdf"
    
    # Copy PDF to main directory with descriptive name
    cp output/main.pdf ExpenseManager_Project_Report.pdf
    echo "✓ Report copied as: ExpenseManager_Project_Report.pdf"
    
    # Clean up auxiliary files (optional)
    echo "Cleaning up auxiliary files..."
    rm -f output/*.aux output/*.log output/*.toc output/*.lof output/*.lot output/*.out
    
    echo "✓ Compilation complete!"
else
    echo "✗ Compilation failed. Check the log files for errors."
    echo "Log file location: output/main.log"
fi