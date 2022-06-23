# A Systematic Review of Human Challenge Trials, Designs, and Safety.

medRxiv preprint DOI: [https://doi.org/10.1101/2022.03.20.22272658](https://doi.org/10.1101/2022.03.20.22272658)

Dataset DOI: [10.5281/zenodo.6711717](https://zenodo.org/record/6711717)

## Dataset

The resulting dataset from this systematic review is provided both as an [Excel file](dataset.xlsm) and a [Google Sheet](https://bit.ly/1DSSR22).  These datasets allow filtering for various exclusions:

1. Challenge - describes a traditional challenge trial
2. Prechallenge - describes an immunization phase or a vaccination phase that occurred prior to a traditional challenge phase
3. Rechallenge - describes a cohort of volunteers that have been previously exposed to a challenge agent (in a previous study or in an earlier challenge phase of the current study), that were then challenged again (either with the same strain or a different strain of the challenge agent)
4. Attenuated - describes a challenge with an attenuated challenge agent
5. Vaccine - describes a challenge with a vaccine
6. NAE - studies where AEs were not mentioned/defined, and other reported data (symptoms, illness, etc.) was extracted instead
7. NSAE - studies where SAEs were not mentioned in the text, and the current FDA definition of SAEs was manually applied to reported symptom/illness data in order to identify possible SAEs
8. Excluded - studies that were excluded for any reason (should always remain checked)
9. Summed - previously extracted data from multiple phases, studies, or cohorts that was summed to be treated as a single study

## Figures

The figures included for publication were produced directly from the Google Sheet (https://bit.ly/1DSSR22) and the source code is provided in [CID-113513.r](CID-113513.r).  This was developend and tested under [R](https://www.r-project.org/) 4.1.3.

You may execute this code within a development environment such as [RStudio](https://www.rstudio.com/), or simply from the R interpreter by issuing the command `Rscript CID-113513.r`.  In the latter environment, the program will produce and EPS and TIF (1200dpi) version of each figure in the publication.

```
06/23/2022  11:03 AM            11,547 CID-113513-figure2.eps
06/23/2022  11:03 AM           474,900 CID-113513-figure2.tiff
06/23/2022  11:03 AM            11,552 CID-113513-figure3.eps
06/23/2022  11:03 AM           883,650 CID-113513-figure3.tiff
06/23/2022  11:03 AM            34,883 CID-113513-figure3a.eps
06/23/2022  11:03 AM           463,836 CID-113513-figure3a.tiff
06/23/2022  11:03 AM            11,547 CID-113513-figure3b.eps
06/23/2022  11:03 AM           346,146 CID-113513-figure3b.tiff
```

## Presentation

The presentation given by Danny Toomey outlining the methodology used for this work is provided in both [Powerpoint](Supplementary%20Material%20-%20Protocol.pptx) and [PDF](Supplementary%20Material%20-%20Protocol.pdf) format.

## Repository Contact

Any questions about this repository may be directed to [James Wilkinson](mailto:james.wilkinson@1daysooner.org).
