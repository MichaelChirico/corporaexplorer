
<!-- README.md is generated from README.Rmd. Please edit that file -->

# corpusexplorationr

<!-- badges: start -->

[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Travis build
status](https://travis-ci.org/kgjerde/corpusexplorationr.svg?branch=master)](https://travis-ci.org/kgjerde/corpusexplorationr)
<!-- badges: end -->

**corpusexplorationr** is an R package for dynamic exploration of text
collections.

<!-- <sup>[1](#myfootnote1)</sup> -->

The intended primary audience is qualitatively oriented researchers who
rely on close reading of textual documents as part of their academic
activity.

Example use cases include:

  - **Datasets that can be freely shared**. someone interested in the
    development of, say, Russian government discourse on, say, democracy
    over the last twenty years. Usually available with CC license or
    similar. Much better than the websites. Often, making such text
    collections available is in itself a service to the scholarly
    community.
  - **Datasets that cannot be freely shared**. E.g. exploring a
    collection of newspaper articles etc. retrieved from a database.
  - **Personal text collections**: any collection of texts that are
    meaningful to explore with a time aspect.
  - **Customised corpora**, e.g. text collections with sentences instead
    of documents as base unit.

While collecting and preparing the text collections to be explored
requires some R programming knowledge, using the Shiny app(s) for
exploring and extracting documents from the corpus should be rather
intuitive also for someone with no programming knowledge – when first
set up by a collaborator.

Thus, the ambition is that package should be useful for anyone with a
rudimentary knowledge of R – or who knows anyone with this knowledge.

**corpusexplorationr** contains three functions:

1.  `prepare_data()` converts a data frame to a corpusexploration
    object.
2.  `run_corpus_explorer()` runs the package’s core feature, a Shiny app
    for fast and flexible exploration of a corpusexploration object.
3.  `run_document_extractor()` runs a Shiny app for simple
    retrieval/extraction of documents from a corpusexploration object in
    a reading-friendly format.

## Installation

To install **corpusexplorationr**, run the following from an R console:

``` r
install.packages("devtools")
devtools::install_github("kgjerde/corpusexplorationr")
```

## 1\. Prepare data for the Shiny apps

The `prepare_data()` function takes a data frame with, as a minimum, a
`Date` and a `Text` column as input and returns a corpusexploration
object that can be explored in the package’s two Shiny apps. The default
arguments should work fine for most use cases.

After installing **corpusexplorationr**, run the following in the R
console to see full documentation for the `prepare_data()` function.

``` r
library(corpusexplorationr)
?prepare_data
```

## 2\. The corpus exploration app

Start the app by running the `run_corpus_explorer()` function with a
corpusexploration object created by `prepare_data()` as argument. Run
the following in the R console to see documentation for the
`run_corpus_explorer()` function.

``` r
library(corpusexplorationr)
?run_corpus_explorer
```

The default arguments are recommended for most use cases.

While it should be possible to use the app without reading any further,
the rest of this section includes user interface instructions as well as
some details about the app’s inner workings that are relevant for
advanced
users.

### 2a. Sidebar input

<img align="left" src="man/figures/sidebar.png" width="170" height="450" style="margin-right: 25px"/>

  - **Number of terms to chart**: How many terms (phrases/patterns)
    should be charted in the corpus map? Current maximum is two.
  - **Term(s) to chart**: The corpus map plot will highlight
    days/documents where these terms are present. The terms will also be
    highlighted in all documents.
  - **Add terms for text highlighting**: Terms included here (one on
    each line) will be highlighted in all documents. An arbitrary number
    of terms can be added.
  - **Filter corpus?** Input terms here (one on each line) will filter
    the corpus so that it includes only documents where all these terms
    are present. Unlike terms entered in the two fields above, these
    terms will not be included in the summary statistics in the “Corpus
    info” tab. An arbitrary number of terms can be used.
  - **Case sensitive search**: Check this box to distinguish between
    lower and upper case in the search. Unchecked, `war` will find both
    “war” and “War”; if checked, `war` will only find “war”.
  - **“Year range” or “date range”**: Filters the corpus (the first and
    last date included) by time span.
  - **Plot mode (“calendar” or “document wall”)**: Should the resulting
    corpus map treat one day or one document as its base unit?
  - **Adjust plot size**: Change plot height. This is the only sidebar
    input that has effect without clicking the search button.
  - **Search button**: Only when search button is clicked will input
    from the sidebar (with the exception of the “Adjust plot size”
    input) be handled by the app.

#### Note: Text input – regular expressions

All text input will be treated as regular expressions (or *regexes*).
Regular expressions can be very powerful for identifying exactly the
text patterns one is interested in, but this power comes at a high
complexity cost. That said, for simple searches that do not include
punctuation, all one needs to know is basically this:

  - `\b` in a search means the beginning or the end of a word.
  - `.` in a search means “any single character”.

Thus, (in a case insensitive search):

``` r
arctic  # will match both 'Arctic' and 'Antarctic'
\barctic  # will match only 'Arctic'.

civili.ation  # will match both 'civilisation' and 'civilization'
```

For more about regex syntax and the regex flavours available, see the
section about regex engines
[below](#advanced-detail-regular-expression-engines).

(N.B. As seen in the example, a single backslash (not a double backslash
as in the R console) is used as escape character. For example will `\.`
match a literal “.”, and `\d` match any digit.)

#### Note: Additional search arguments

**corpusexplorationr** offers two optional arguments that can be used
separately or together by adding them to the end of a search pattern
(with no space between):

1.  The “treshold argument” has the syntax `--treshold` and determines
    the minimum number of search hits a document should contain in order
    to be highlighted in the corpus
map:

<!-- end list -->

``` r
Russia--10  # Will find documents that includes the pattern "Russia" at least 10 times.
```

2.  The “column argument” has the syntax `--column_name` and allows for
    searches in other columns than the default full text
column:

<!-- end list -->

``` r
Russia--Title  # Will find documents that has the pattern "Russia" in its "Title" column.
```

3.  The two arguments can be combined in any order:

<!-- end list -->

``` r
Russia--2--Title
Russia--Title--2
# Will both find documents that includes the pattern "Russia" at least 2 times
# in the Title column.
```

These arguments have the following consequences:

  - *If used in the “Term(s) to chart” fields*: The corpus map plot will
    highlight documents that satisfy the search arguments. Likewise, the
    summary statistics displayed in the “Corpus info” tab will be based
    on the documents matching the search arguments. In the document
    themselves, all pattern matches will be highlighted. For example, a
    search for `Russia--Title` will highlight only documents with the
    pattern Russia in the Title column, but the pattern Russia will be
    highlighted in all documents.
  - *If used in the “Add terms for highlighting” field*: The pattern
    will be highlighted in all documents. The summary statistics
    displayed in the “Corpus info” tab will be based on the documents
    matching the search arguments.
  - *If used in the “Filter corpus” field*: The corpus will be filtered
    to include only documents that match the search arguments.

### 2b. Corpus map

The result of the search is an interactive heat map, a **corpus map**,
where the colour fill indicates how many times the search term is found
(legend above the plot).

In the **calendar view** (the default), each tile represents a day, and
the colour fill indicates how many time the search term is found in the
documents that day:

<img src="man/figures/first_search.png" width="80%" />

<br>

In the **document wall view**, each tile represents one document, and
the colour fill indicates how many time the search term is found in this
document:

<img src="man/figures/wall_1.png" width="80%" />

<br>

The **Corpus info** tab presents some very basic summary statistics of
the search results. (Look at e.g.
[`tidytext`](https://github.com/juliasilge/tidytext) and
[`quanteda`](https://github.com/quanteda/quanteda) for excellent R
packages for *quantitative* text analysis. Using such packages together
with **corpusexplorationr** is highly recommended in order to combine
qualitative and quantitative insights.)

Clicking on a tile in the corpus map opens the **document view** to the
right of the corpus map.

### 2c. Document view

**When in calendar view**: Clicking on a day creates a second heat map
tile chart where one tile is one document, and where the colour in a
tile indicates how many times the search term is found in the document.
In the box below is produced a list of the title of the documents this
day.

<img src="man/figures/day_corpus.png" width="80%" />

<br>

Clicking on a “document tile” produces two things. First, the full text
of the document with search terms highlighted. Second, above the text a
tile chart consisting of n tiles where each tile represents a 1/n part
of the document, and where the colour in a tile indicates whether and
how many times the search term is found in that part of the document.
Clicking on a tile scrolls the document to the corresponding part of the
document.

<img src="man/figures/wall.png" width="80%" />

**When in document wall view**: Clicking on a tile in the corpus map
leads straight to the highlighted document.

### 2d. Advanced detail: Regular expression engines

`run_corpus_exploration()` lets you choose among three regex engine
setups:

1.  `default`: use the [`re2r`](https://github.com/qinwf/re2r) package
    for simple searches and the
    [`stringr`](https://github.com/tidyverse/stringr) package for
    complex regexes (details below). This is the recommended option.
2.  use `stringr` for all searches.
3.  use `re2r`for all searches.

`re2r` is very fast but allows for less advanced regular expressions
than `stringr` and is more limited when in handling non-ASCII text. With
the `default` option, the `re2r` engine is run when no special regex
characters are used; otherwise the `stringr` engine and syntax is used.
This option should fit most use cases.

Please consult the documentation for
[`re2r`](https://github.com/qinwf/re2r) and
[`stringr`](https://github.com/tidyverse/stringr) for full information
about syntax flavours.

Advanced users can set the `optional_info` parameter in
`run_corpus_exploration()` to `TRUE`: this will print to console the
following information for each input term: which regex engine was used,
and whether the search was carried out in the document term matrix or in
the full text documents.

## 3\. The download documents app

This app is a simple helper app to retrieve a subset of the corpus in a
format suitable for close reading.

<img src="man/figures/download_tool.png" width="80%" />

Start the app by running the `run_document_extractor()` function with a
corpusexploration object created by `prepare_data()` as argument. Run
the following in the R console to see documentation for the
`run_document_extractor()` function.

``` r
library(corpusexplorationr)
?run_document_extractor
```

### 3a. Sidebar input

  - **Term(s) to highlight**: An arbitrary number of search terms
    (regular expressions) that will be highlighted in the documents in
    the produced HTML reports.
  - **Filter corpus?**: Input terms here (one on each line) will filter
    the corpus so that it includes only documents where all these terms
    are present. Unlike terms entered in the two fields above, these
    terms will not be included in the summary statistics in the “Corpus
    info” tab. An arbitrary number of terms can be used.
  - **Case sensitive search**: Check this box to distinguish between
    lower and upper case in the search. Unchecked, `war` will find both
    “war” and “War”; if checked, `war` will only find “war”.
  - **“Year range” or “date range”**: Filters the corpus (the first and
    last date included).

By default, there is an upper limit of 400 documents to be included in
one report (can be changed in the `max_html_docs` parameter in
`run_document_extractor()`).

### 3b. Advanced detail: Regular expression engines

Speed is considered to be of less importance in this app, and all
searches are carried out as full text searches with `stringr`.

Again, note that a single backslash is used as escape character. For
example will `\.` match a literal “.”, and `\d` match any digit.

<!-- <a name="myfootnote1">1</a>: Footnote content goes here -->
