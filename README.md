# Long-range organization of intestinal 2D-crypts using exogenous Wnt3a micropatterning, by Larrañaga et al.  

This repository contains four tools for the anlysis reported in the manuscript Long-range organization of intestinal 2D-crypts using exogenous Wnt3a micropatterning by Enara Larrañaga, Miquel Marin-Riera, Aina Abad-Lázaro, David Bartolomé-Català, Aitor Otero, Vanesa Fernández-Majada, Eduard Batlle, James Sharpe, Samuel Ojosnegros, Jordi Comelles and Elena Martinez, including MATLAB scripts and Fiji macros. These tools enable 2D cell contour mapping, colocalization analysis, Delaunay triangulation, and Matrigel thickness estimation. Below, we outline the purpose, functionality, and usage of each tool.

---

## 1. **Matrigel Thickness Estimation**  

### Overview  
This Fiji/ImageJ macro estimates Matrigel layer thickness using confocal microscopy images. Orthogonal views of laminin-stained confocal stacks are processed to generate intensity profiles, which are fitted to a Gaussian distribution. Thickness is determined via the full width at half maximum (FWHM).  

### Input Requirements  
- **Confocal Image Stack**: Laminin-stained confocal images.  

### Outputs  
- **Matrigel Thickness**: Calculated for each cross-sectional profile.  

### Usage Instructions  
1. Open Fiji and load the confocal image data. 
2. Run the script `FWHM_Line_Gaussian.ijm` in Fiji or ImageJ.  
3. Results are displayed in the console or saved as outputs.  

---

## 2. **2D Cell Area Contour Mapping**  

### Overview  
This MATLAB script creates contour maps of cell areas based on centroid positions and cell sizes from segmented 2D monolayers. The maps are visualized in logarithmic scale for enhanced interpretation.  

### Input Requirements  
- **Excel File (`.xls`)**:  
  - `area_1`: Column vector of cell areas.  
  - `xy0`: Numeric matrix of cell centroid positions.  

### Outputs  
- **Contour Maps**: Log-scale representation of cell areas.  
- **Histograms**: Frequency distribution of cell areas.  

### Usage Instructions  
1. Load the `.xls` file containing `area_1` and `xy0` according to the input requirements.  
2. Run `proliferative_vs_area.m` in MATLAB.  
3. The contour maps and histograms will be displayed and saved.  

---

## 3. **Delaunay Triangulation and Triangle Analysis**  

### Overview  
This MATLAB script performs Delaunay triangulation on 2D coordinate data, calculates triangle angles and side lengths, and visualizes the triangulation. Results are exported to `.csv` files for further analysis.  

### Input Requirements  
- **Matrix (`Results`)**:  
  - Column 7: X-coordinates.  
  - Column 8: Y-coordinates.  

### Outputs  
- **`angles_degrees.csv`**: Triangle angles in degrees.  
- **`side_lengths.csv`**: Unique side lengths of triangles.  
- **Plots**:  
  - Delaunay triangulation.  
  - Histogram of triangle angles.  

### Usage Instructions  
1. Ensure `Results` matrix is loaded in MATLAB and organized according to the input requirements.  
2. Run the script and follow prompts for data processing.  
3. Review exported `.csv` files and visual plots.  

---

## 4. **Pixel-Based Colocalization Analysis**  

### Overview  
This Fiji macro analyzes pixel-based colocalization of markers in multi-channel images. It segments nuclei, identifies proliferative and stem cell regions, and quantifies colocalization between markers.  

### Input Requirements  
- **Composite Image**: 20X stack with the following channels:  
  - Channel 1: Actin.  
  - Channel 2: GFP/Stem cell marker.  
  - Channel 3: Nuclei/DAPI.  
  - Channel 4: Ki67/Proliferative marker.  

### Outputs  
- **Console Logs**:  
  - Area coverage.  
  - Cell counts for markers.  
  - Colocalization statistics.  
- **ROI Manager**: Segmented regions as ROI selections.  
- **Processed Images**: For each analyzed channel.  

### Usage Instructions  
1. Open Fiji and load the composite image.  
2. Run the macro and input required parameters.  
3. Review quantitative results in the console and ROI Manager.  

---

## Requirements  

### Software  
- **MATLAB** (for MATLAB scripts).  
- **Fiji (ImageJ)** (for macros).  

### Plugins and Dependencies  
- **FeatureJ** (for Laplacian smoothing in Fiji).  

---
