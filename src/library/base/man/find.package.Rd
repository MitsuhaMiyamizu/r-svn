% File src/library/base/man/find.package.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2018 R Core Team
% Distributed under GPL 2 or later

\name{find.package}

\alias{find.package}
\alias{path.package}
\alias{packageNotFoundError}

\title{Find Packages}
\description{
  Find the paths to one or more packages.
}
\usage{
find.package(package, lib.loc = NULL, quiet = FALSE,
             verbose = getOption("verbose"))

path.package(package, quiet = FALSE)

packageNotFoundError(package, lib.loc, call = NULL)
}
\arguments{
  \item{package}{character vector: the names of packages.}
  \item{lib.loc}{a character vector describing the location of \R
    library trees to search through, or \code{NULL}.  The default value
    of \code{NULL} corresponds to checking the loaded namespace, then
    all libraries currently known in \code{\link{.libPaths}()}.}
  \item{quiet}{logical.  Should this not give warnings or an error
    if the package is not found?}
  \item{verbose}{a logical.  If \code{TRUE}, additional diagnostics are
    printed, notably when a package is found more than once.}
  \item{call}{call expression.}
}
\details{
  \code{find.package} returns path to the locations where the
  given packages are found.  If \code{lib.loc} is \code{NULL}, then
  loaded namespaces are searched before the libraries.  If a package is
  found more than once, the first match is used.  Unless \code{quiet =
  TRUE} a warning will be given about the named packages which are not
  found, and an error if none are.  If \code{verbose} is true, warnings
  about packages found more than once are given.  For a package to be
  returned it must contain a either a \file{Meta} subdirectory or a
  \file{DESCRIPTION} file containing a valid \code{version} field, but
  it need not be installed (it could be a source package if
  \code{lib.loc} was set suitably).

  \code{find.package} is not usually the right tool to find out if a
  package is available for use: the only way to do that is to use
  \code{\link{require}} to try to load it.  It need not be installed for
  the correct platform, it might have a version requirement not met by
  the running version of \R, there might be dependencies which are not
  available, \dots.

  \code{path.package} returns the paths from which the named packages
  were loaded, or if none were named, for all currently attached packages.
  Unless \code{quiet = TRUE} it will warn if some of the packages named
  are not attached, and given an error if none are.

  \code{packageNotFoundError} creates an error condition object of class
  \code{packageNotFoundError} for signaling errors. The condition object
  contains the fields \code{package} and \code{lib.loc}.  
}
\seealso{
  \code{\link{path.expand}} and \code{\link{normalizePath}} for path
  standardization.
}
\value{
  A character vector of paths of package directories.
}
\examples{
try(find.package("knitr"))
## will not give an error, maybe a warning about *all* locations it is found:
find.package("kitty", quiet=TRUE, verbose=TRUE)

## Find all .libPaths() entries a package is found:
findPkgAll <- function(pkg)
  unlist(lapply(.libPaths(), function(lib)
           find.package(pkg, lib, quiet=TRUE, verbose=FALSE)))

findPkgAll("MASS")
findPkgAll("knitr")
}
\keyword{file}
