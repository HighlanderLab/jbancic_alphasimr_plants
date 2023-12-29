# Plant breeding simulations with AlphaSimR

## Introduction

This repository contains R scripts that demonstrate simulations of plant breeding programs and techniques using AlphaSimR https://cran.r-project.org/package=AlphaSimR. These scripts and the process of simulating plant breeding program are described in:

Bancic et al. (2023) bioRxiv TODO

    @article{BancicEtAl2023,
      title = {Plant breeding simulations with AlphaSimR},
      author = {Bančič, Jon and Greenspoon, Philip and Gaynor, R Chris and Gorjanc, Gregor},
      journal = {bioRxiv},
      year = {2023},
      doi = {TODO}
    }

## Repository contents

  * `01_LineBreeding` folder contains scripts for simulating a line breeding program, such as in wheat and other selfing species. The scripts show several types of a phenotypic selection strategies (mass selection, single seed descent, pedigree selection, and doubled haploids) and genomic selection strategies (conventional and two-part).

  * `02_ClonalBreeding` folder contains scripts for simulating a clonal breeding program, such as in tea and other clonal species. The scripts show a phenotypic, pedigree, or genomic selection strategies.

  * `03_HybridBreeding` folder contains scripts for simulating a clonal breeding program, such as in maize and other outcrossing species. The scripts show a phenotypic selection strategy and two genomic selection strategies (conventional and two-part).

  * `04_Techiques` folder contains scripts for simulating plant breeding programs using various breeding and genetic techniques. The scripts show:
  
    * Trait introgression (`traitIntrogression.R`)
  
    * Speed breeding (`speedBreeding.R`)
  
    * Genome editing (`genomeEditing.R`)
    
    * Multi-trait selection with selection index (`multipleTraits.R`)
    
    * Miscellaneous slot to store user-defined information (`miscellaneousSlot.R`)
    
    * Mating plans (`matingPlans.R`)
    
    * GWAS (`simulateGWAS.R`)
    
    * Import external haplotypes (`importExternalHaplo.R`)
    
    * Specifying demography for simulating founder genomes (`specifyDemography.R`)
    
    * Genomic prediction & selection models (`genomicModels.R`)
    
    * Setting heritability (`setHeritability.R`)
    
    * Functions used across scripts (`functions.R`)

  * `jbancic_alphasimr_plants.Rproj` is the RStudio/Posit project file (to set working directory etc.).

  * `LineBreeding.Rmd` (and its output `LineBreeding.html`) - TODO

  * `README.md` is this file.

## HOWTO

  1) Download this whole repository
  
  2) In RStudio/Posit open project file `jbancic_alphasimr_plants.Rproj`
  
  3) For each of the three types of plant breeding programs, select a folder
     and work through `00RUNME.R` file to run simulations and then work through
     `ANALYZERESULTS.R` file to analyze results.
