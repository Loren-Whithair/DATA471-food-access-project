# DATA471 individual report

This project aims to build a **Logistic Regression** model to predict low income + low access

Indicator vars include population counts (ethnicity, age), Urban/Rural splits.
- interactions between them will be explored (Urban and Rural have reverse effects on Income)
- one of the ethnicity variables will be omitted, considered the "reference variable"
- location (e.g. State) was not considered significant enough to include for the purpose of this report.


## Links
The dataset: [Food Access](https://www.ers.usda.gov/data-products/food-access-research-atlas/documentation)

This report uses the 2019 LRAM data (documentation [here](https://www.ers.usda.gov/data-products/food-access-research-atlas/documentation/large-retailer-access-map-reference-guide))

### Group project links
- [Planning document](https://docs.google.com/document/d/1PyXEA0M4us3B3TdizhHsWr8UbPKlXWLnFqNysjsH0QY/edit?tab=t.0)
- [2019 FARA variable lookup](https://docs.google.com/spreadsheets/d/1uyvREUAhV1yKDUmPbk2gbF8L4oM8AwzEDMmS0bFhzZM/edit?gid=964893733#gid=964893733)
- [2025 SRAM variable lookup](https://docs.google.com/spreadsheets/d/1IYKyRGcHnefbHvXBJkAp4avvkRp3IjlQOheCJe80q_U/edit?gid=143586456#gid=143586456)



#### (OLD) Rendering the group report to PDF

`group_report.Rmd` is the RMD file that renders the final report. Other files contain draft versions of various components, and other EDA work that didn't make the final cut.

One-time setup (once per machine, works the same on Mac/Windows/Linux):
```r
install.packages(c("rmarkdown", "tinytex"))
tinytex::install_tinytex()
```
This installs a small (~150MB) LaTeX that belongs to R alone, separate
from any LaTeX already on your machine, so it won't conflict with one.
Everyone in the group should use this instead of a system LaTeX
install (MacTeX, MiKTeX, ...) - it auto-installs any package the report
needs the first time it's missing, so nobody has to manually chase
"package X not found" errors.

To render: pull the full repo first (the report needs `figures/`
next to it, not just the one file), then in RStudio open
`group_report.Rmd` and click Knit, or run:
```r
rmarkdown::render("group_report.Rmd")
```
The first render can take a minute while tinytex fetches any missing
package - only happens once.
