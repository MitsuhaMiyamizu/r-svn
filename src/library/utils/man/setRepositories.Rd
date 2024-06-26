% File src/library/utils/man/setRepositories.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2024 R Core Team
% Distributed under GPL 2 or later

\name{setRepositories}
\alias{setRepositories}
\alias{R_REPOSITORIES}
\alias{R_BIOC_VERSION}
\title{Select Package Repositories}
\description{
  Interact with the user to choose the package repositories to be used.
}
\usage{
setRepositories(graphics = getOption("menu.graphics"),
                ind = NULL, addURLs = character(), name = NULL)
}
\arguments{
  \item{graphics}{Logical. If true, use a graphical list: on Windows or
    macOS GUI use a list box, and on a Unix-alike if \pkg{tcltk} and an X
    server are available, use Tk widget. Otherwise use a text
    \code{\link{menu}}.}
  \item{ind}{\code{NULL} or a vector of integer indices, which have the
    same effect as if they were entered at the prompt for
    \code{graphics = FALSE}.}
  \item{name}{\code{NULL} or character vector of names of the
    repositories in the repository table which has the same effect as
    passing the corresponding indices to \code{ind}.}
  \item{addURLs}{A character vector of additional URLs: it is often
    helpful to use a named vector.}
}
\details{
  The default list of known repositories is stored in the file
  \file{\var{\link{R_HOME}}/etc/repositories}.
  That file can be edited for a site, or a user can have a personal copy
  in the file pointed to by the environment variable
  \env{R_REPOSITORIES}, or if this is unset, \code{NULL} or does not exist,
  in \file{\var{HOME}/.R/repositories}, which will take precedence.

  A Bioconductor mirror can be selected by setting
  \code{\link{options}("BioC_mirror")}, e.g.\sspace{}via
  \code{\link{chooseBioCmirror}} --- the default value is
  \samp{"https://bioconductor.org"}.
  This version of R chooses Bioconductor version \Sexpr{
    utils:::.BioC_version_associated_with_R_version_default
  } by default, but that can be changed via the environment variable
  \env{R_BIOC_VERSION}.

  The items that are preselected are those that are currently in
  \code{options("repos")} plus those marked as default in the
  list of known repositories.

  The list of repositories offered depends on the setting of option
  \code{"pkgType"} as some repositories only offer a subset of types
  (e.g., only source packages or not macOS binary packages).
  Further, for binary packages some repositories (notably R-Forge) only
  offer packages for the current or recent versions of \R.
  (Type \code{"both"} is equivalent to \code{"source"}.)

  Repository \samp{CRAN} is treated specially: the value is taken from
  the current setting of \code{getOption("repos")} if this has an
  element \code{"CRAN"}: this ensures mirror selection is sticky.

  This function requires the \R session to be interactive unless
  \code{ind} or \code{name} is supplied. The latter overrides the former
  if both are supplied and values are not case-sensitive. If any of the
  supplied names does not match, an error is raised.
}
\note{
  This does \strong{not} set the list of repositories at startup: to do
  so set \code{\link{options}(repos =)} in a start up file (see help topic
  \link{Startup}) or via a customized \file{repositories} file.
}
\value{
  This function is invoked mainly for its side effect of updating
  \code{options("repos")}.  It returns (invisibly) the previous
  \code{repos} options setting (as a \code{\link{list}} with component
  \code{repos}) or \code{\link{NULL}} if no changes were applied.
}
\seealso{
  \code{\link{chooseCRANmirror}}, \code{\link{chooseBioCmirror}},
  \code{\link{install.packages}}.
}
\examples{\dontrun{
setRepositories(addURLs =
                c(CRANxtras = "https://www.stats.ox.ac.uk/pub/RWin"))
}
oldrepos <- setRepositories(name = c("CRAN", "R-Forge"))
\donttest{getOption("repos")}
options(oldrepos) # restore
}
\keyword{ utilities }
