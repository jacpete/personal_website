---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "MoveBank Exploratory Data Analysis"
summary: " "
authors: []
#tags:
#  - Data Science Portfolio
project_tags:
  - Data Science Portfolio Test
categories: []
date: 2020-02-24T14:26:37-05:00

# Optional external URL for project (replaces project detail page).
external_link: ""

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Custom links (optional).
#   Uncomment and edit lines below to show custom links.
# links:
# - name: Follow
#   url: https://twitter.com
#   icon_pack: fab
#   icon: twitter

url_code: ""
url_pdf: ""
url_slides: ""
url_video: ""

# Slides (optional).
#   Associate this project with Markdown slides.
#   Simply enter your slide deck's filename without extension.
#   E.g. `slides = "example-slides"` references `content/slides/example-slides.md`.
#   Otherwise, set `slides = ""`.
slides: ""
---

# Project Overview:

The linked blog post below was originally used to create my final project for the ABE 651 (*Environmental Informatics*) class I took while at Purdue University.
I am now repurposing it to use as an example in my data science portfolio I am putting together to host on my [website](https://www.jacobmpeterson.com/) and [Github](https://github.com/jacpete//).

The purpose of this class project was meant to demonstrate our ability to find and manage a publicly available dataset, perform exploratory graphical analysis, run a data quality checking sequence, and perform a simple statistical analysis on the data.
The project was meant to be open ended so that students could use data they had specific interests in and I chose to explore animal movement data from the data repository site [MoveBank](https://www.datarepository.movebank.org/).

A GitHub repository with the data and code used to create this document can be found [here](https://github.com/jacpete/portfolio_DataExplorationAndCleaning_MovebankData//).


# Abstract

With this project, I explored the offerings of an animal movement data repository and created a Rmarkdown document that contained the code used to clean, format, and explore the data available at [MoveBank](https://www.datarepository.movebank.org/).
I chose to use data depicting movements of barnacle geese in Northern Europe and the North Atlantic within three separate sub-populations.
With this data, I examined the regional differences in displacement between the summer and winter ranges as well as differences in summer home range size using one-way ANOVA's.
Using post-hoc Tukey tests, I discovered that there was a significant difference in seasonal displacement between the Barents Sea and Greenland sub-populations.
However, there was no significant variation between summer home range size in the sub-populations.

