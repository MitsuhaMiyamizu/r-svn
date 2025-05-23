% File src/library/stats/man/terms.object.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2023 R Core Team
% Distributed under GPL 2 or later

\name{terms.object}
\title{Description of Terms Objects}
\alias{terms.object}
\description{
  An object of class \code{\link{terms}} holds information about a
  model.  Usually the model was specified in terms of a
  \code{\link{formula}} and that formula was used to determine the terms
  object.
}
\details{
  The object itself is simply the result of \code{\link{terms.formula}(<formula>)}.
  It has a number of attributes
  and they are used to construct the model frame:

  \describe{
  \item{\code{factors}}{An integer matrix of variables by terms showing which variables
    appear in which terms.  The entries are \describe{
      \item{0 }{if the variable does not occur in the term,}
      \item{1 }{if it does occur and should be coded by contrasts, and}
      \item{2 }{if it occurs and should be coded via dummy variables for
	all levels (as when a lower-order term is missing).} }
    Note that variables in main effects always receive 1,
    even if the intercept is missing (in which case the first one
    should be coded with dummy variables).
    If there are no terms other than an intercept and offsets,
    this is \code{\link{integer}(0)}.
  }
  \item{\code{term.labels}}{A character vector containing the labels for each
    of the terms in the model, except for offsets.  Note that these are
    after possible re-ordering of terms.

    Non-syntactic names will be quoted by backticks: this makes it
    easier to re-construct the formula from the term labels.
  }
  \item{\code{variables}}{A call to \code{list} of the variables in the model.}
  \item{\code{intercept}}{Either 0, indicating no intercept is to be fit, or 1
    indicating that an intercept is to be fit.}
  \item{\code{order}}{A vector of the same length as \code{term.labels}
    indicating the order of interaction for each term.}
  \item{\code{response}}{The index of the variable (in \code{variables}) of the
    response (the left hand side of the formula).  Zero, if there is no
    response.}
  \item{\code{offset}}{If the model contains \code{\link{offset}} terms there
    is an \code{offset} attribute indicating which \code{variables} are offsets.}
  \item{\code{specials}}{If a \code{specials} argument was given to
    \code{\link{terms.formula}} there is a \code{specials} attribute, a
    pairlist of vectors (one for each specified special function) giving
    numeric indices of the arguments of the list returned as the
    \code{variables} attribute which contain these special functions.}
  \item{\code{dataClasses}}{optional.  A named character vector giving the classes
    (as given by \code{\link{.MFclass}}) of the variables used in a fit.}
  \item{\code{predvars}}{optional.  An expression to help in computing
    predictions at new covariate values; see \code{\link{makepredictcall}}.}
  }
  
  The object has class \code{c("terms", "formula")}.
}
\note{
  These objects are different from those found in S.  In particular
  there is no \code{formula} attribute: instead the object is itself a
  formula.  (Thus, the mode of a terms object is different.)

  Examples of the \code{specials} argument can be seen in the
  \code{\link{aov}} and \code{\link[survival]{coxph}} functions, the
  latter from package \CRANpkg{survival}.
}
\seealso{
  \code{\link{terms}}, \code{\link{formula}}.
}
\examples{
## use of specials (as used for gam() in packages mgcv and gam)
(tf <- terms(y ~ x + x:z + s(x), specials = "s"))
## Note that the "factors" attribute has variables as row names
## and term labels as column names, both as character vectors.
attr(tf, "specials")    # index 's' variable(s)
rownames(attr(tf, "factors"))[attr(tf, "specials")$s]

## we can keep the order by
terms(y ~ x + x:z + s(x), specials = "s", keep.order = TRUE)

## use of '::' in terms to be marked as special is *wrong*
ff <- list(y ~        offset(w) + x1 +       s(x2),
           y ~ stats::offset(w) + x1 + mgcv::s(x2))
tt <- lapply(ff, terms, specials = c("s", "mgcv::s"))
lapply(tt, attr, "offset")
lapply(tt, attr, "specials")
}
%%--- MM: I would really like instructive examples here...
\keyword{models}
