
<!-- README.md is generated from README.Rmd. Please edit that file -->

# golem.reprex

This is a reprex for reproducing the bug discussed here:

<blockquote class="twitter-tweet">

<p lang="en" dir="ltr">

<a href="https://twitter.com/hashtag/rstats?src=hash&amp;ref_src=twsrc%5Etfw">\#rstats</a>
devs: has anyone managed to use pagedown::chrome\_print() in a docker
container? I keep on getting “Failed to generate output in 30 seconds
(timeout).”

</p>

— Felipe Mattioni Maturana (@felipe\_mattioni)
<a href="https://twitter.com/felipe_mattioni/status/1317119659574001667?ref_src=twsrc%5Etfw">October
16, 2020</a>

</blockquote>

<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## The bug

The bug is that when run locally, everything works, but the problem is
that when the same is run in a docker container, the PDF fails to be
generated by `pagedown::chrome_print()`. This is caused by the Rmarkdown
template in `inst/app/www/Untitled.Rmd`. On line 17 the following
setting are specified in the chunk: `fig.width=30, fig.height=40`. If
this is removed, everything works in the docker container.

## Docker

Docker image built with:

`docker build -t golem.reprex .`

Docker image run with:

`docker run -it -p 3838:3838 golem.reprex`