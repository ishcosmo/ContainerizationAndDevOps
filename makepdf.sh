#!/bin/bash

# ===== STUDENT DETAILS =====
TITLE="Cloud Computing & DevOps Lab Report"
AUTHOR="Ishita"
SAPID="500119435"

# ===== URLs (Update these with your actual GitHub Pages links) =====
URLS=(
  "https://ishcosmo.github.io/ContainerizationAndDevOps/"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment1"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment2"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment3"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment4"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment5"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment6"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment7"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment9"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment10"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment11"
  "https://ishcosmo.github.io/ContainerizationAndDevOps/LAB/Experiment12"
  
)

# ===== GENERATE PDF =====
pandoc "${URLS[@]}" \
  -o Lab_Report_Final.pdf \
  --pdf-engine=xelatex \
  --toc \
  --number-sections \
  -V geometry:margin=1in \
  -M title="$TITLE" \
  -M author="$AUTHOR ($SAPID)"

echo "PDF generated: Lab_Report_Final.pdf"
