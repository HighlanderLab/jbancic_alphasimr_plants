## Simulation of plant breeding programs in AlphaSimR

This repository contains code for simulating self-pollinating, clonal, and hybrid breeding programs, as well as demonstrating various breeding techniques and showcasing features from the publication by Bancic et al. 2024 (DOI: currently under revision in The Plant Genome).

## File and Directory Descriptions

**LineBreeding.Rmd:** Walk-through R code to follow along with the Results section of the manuscript. \

#### Directory 01_LineBreeding

Contains codes for simulating wheat line breeding programs adapted from Gaynor et al. 2017.

Contents: \
- **RUNME_all.R:** Runs phenotypic and genomic programs for Figure 6 in the manuscript. \
- **PaperPlot.R:** Generates a plot for Figure 6 in the manuscript with input from RUNME_all.R. \
- **01\_PhenotypicSelection/01\_MassSelection/:** Simulates a mass breeding program. \
- **01\_PhenotypicSelection/02\_SingleSeedDescent/:** Simulates a single seed descent breeding program. \
- **01\_PhenotypicSelection/03\_PedigreeSelection/:** Simulates a pedigree breeding program. \
- **01\_PhenotypicSelection/04\_DoubledHaploid/:** Simulates a line program with doubled haploid technology. \
- **02\_GenomicSelection/:** Simulates a line breeding program with conventional genomic selection implementation. \
- **03\_TwoPartGS/:** Simulates a line breeding program with a two-part strategy genomic selection. \

#### Directory 02_ClonalBreeding

Contains codes for simulating tea clonal breeding programs adapted from Lubanga et al. 2017.

Contents: \
- **01\_PhenotypicSelection/:** Simulates a clonal breeding program with phenotypic selection. \
- **02\_PedigreeSelection/:** Simulates a clonal breeding program with pedigree-assisted selection. \
- **03\_GenomicSelection/:** Simulates a clonal breeding program with conventional genomic selection implementation. \

#### Directory 03_HybridBreeding

Contains codes for simulating maize hybrid breeding programs adapted from Powell et al. 2021.

Contents: \
- **01\_PhenotypicSelection/:** Simulates a maize hybrid breeding program with phenotypic selection. \
- **02\_GenomicSelection/:** Simulates a maize hybrid breeding program with genomic selection. \
- **03\_TwoPartGS/:** Simulates a maize hybrid breeding program with a two-part strategy genomic selection. \

#### Directory 04_Techniques

Contains codes for simulating breeding techniques and AlphaSimR features.

Contents: \
- **traitIntrogression.R:** Demonstrates trait integration with backcrossing and MAS. \
- **speedBreeding.R:** Demonstrates speed breeding technique. \
- **genomeEditing.R:** Demonstrates genome editing of a single locus. \
- **multipleTraits.R:** Demonstrates simulation of multiple traits and index selection. \
- **miscellaneousSlot.R:** Demonstrates the use of the miscellaneous slot. \
- **matingPlans.R:** Demonstrates simulation of different mating designs. \
- **simulateGWAS.R:** Demonstrates simulation of a population for a GWAS study. \
- **genomicModels.R:** Demonstrates the use of different genomic models in AlphaSimR. \
- **setHeritability.R:** Demonstrates different approaches to set heritability of phenotypes. \
- **importExternalHaplo.R:** Demonstrates importing external markers. \
- **specifyDemography.R:** Demonstrates specifying one’s own demography. \


## Running Scripts

To run a breeding program, each breeding program directory contains a `00RUNME.R` script that can be executed from a personal computer, calling all other scripts in the order outlined in the manuscript.

To run different techniques, execute scripts independently.

#### Generating Figures

Each breeding program directory includes an `ANALYZERESULTS.R` script that generates simple plots of simulation outputs stored in .rds files. The 01_LineBreeding directory contains the `PaperPlot.R` script, which generates a plot for Figure 6 in the manuscript.
