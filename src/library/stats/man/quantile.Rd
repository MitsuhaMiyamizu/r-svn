% File src/library/stats/man/quantile.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2025 R Core Team
% Distributed under GPL 2 or later

\name{quantile}
\title{Sample Quantiles}
\alias{quantile}
\alias{quantile.default}
\description{
  The generic function \code{quantile} produces sample quantiles
  corresponding to the given probabilities.
  The smallest observation corresponds to a probability of 0 and the
  largest to a probability of 1.
}
\usage{
quantile(x, \dots)

\method{quantile}{default}(x, probs = seq(0, 1, 0.25), na.rm = FALSE,
         names = TRUE, type = 7, digits = 7,
         fuzz = if(type == 7L) 0 else 4 * .Machine$double.eps,
         \dots)
}
\arguments{
  \item{x}{numeric vector whose sample quantiles are wanted, or an
    object of a class for which a method has been defined (see also
    \sQuote{details}). \code{\link{NA}} and \code{NaN} values are not
    allowed in numeric vectors unless \code{na.rm} is \code{TRUE}.}
  \item{probs}{numeric vector of probabilities with values in
    \eqn{[0,1]}.  (Values up to \samp{2e-14} outside that
    range are accepted and moved to the nearby endpoint.)}
  \item{na.rm}{logical; if true, any \code{\link{NA}} and \code{NaN}'s
    are removed from \code{x} before the quantiles are computed.}
  \item{names}{logical; if true, the result has a \code{\link{names}}
    attribute.  Set to \code{FALSE} for speedup with many \code{probs}.}
  \item{type}{an integer between 1 and 9 selecting one of the
    nine quantile algorithms detailed below to be used.}
  \item{digits}{used only when \code{names} is true: the precision to use
    when formatting the percentages.  In \R versions up to 4.0.x, this had
    been set to \code{max(2, getOption("digits"))}, internally.}
  \item{fuzz}{small non-negative number to protect against rounding errors
    when \code{j <- \link{floor}(np + m)}, (\eqn{np} \dQuote{a version of}
    \code{n * probs}, see the formula below), is computed.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\details{
  A vector of length \code{length(probs)} is returned;
  if \code{names = TRUE}, it has a \code{\link{names}} attribute.

  \code{\link{NA}} and \code{\link{NaN}} values in \code{probs} are
  propagated to the result.

  The default method works with classed objects sufficiently like
  numeric vectors that \code{sort} and (not needed by types 1 and 3)
  addition of elements and multiplication by a number work correctly.
  Note that as this is in a namespace, the copy of \code{sort} in
  \pkg{base} will be used, not some S4 generic of that name.  Also note
  that that is no check on the \sQuote{correctly}, and so
  e.g.\sspace{}\code{quantile} can be applied to complex vectors which (apart
  from ties) will be ordered on their real parts.

  There is a method for the date-time classes (see
  \code{"\link{POSIXt}"}).  Types 1 and 3 can be used for class
  \code{"\link{Date}"} and for ordered factors.

  \code{fuzz := 4 * .Machine$double.eps} has been hard coded and used for
  \code{type = 4,5,6, 8,9} since \code{type}s were introduced, % r30628, 2004-08-12
  and is used, since \R 4.5.0, also for the other types (but with default
  \code{0} for the default \code{type = 7} for back compatibility reasons).
}
\section{Types}{
  \code{quantile} returns estimates of underlying distribution quantiles
  based on one or two order statistics from the supplied elements in
  \code{x} at probabilities in \code{probs}.  One of the nine quantile
  algorithms discussed in \bibcite{Hyndman and Fan (1996)}, selected by
  \code{type}, is employed.

  All sample quantiles are defined as weighted averages of
  consecutive order statistics. Sample quantiles of type \eqn{i}
  are defined by:
  \deqn{Q_{i}(p) = (1 - \gamma)x_{j} + \gamma x_{j+1}}{Q[i](p) = (1 - \gamma) x[j] + \gamma x[j+1],}
  where \eqn{1 \le i \le 9},
  \eqn{\frac{j - m}{n} \le p < \frac{j - m + 1}{n}}{(j-m)/n \le p < (j-m+1)/n},
  \eqn{x_{j}}{x[j]} is the \eqn{j}-th order statistic, \eqn{n} is the
  sample size, the value of \eqn{\gamma} is a function of
  \eqn{j = \lfloor np + m\rfloor}{j = floor(np + m)} and \eqn{g = np + m - j},
  and \eqn{m} is a constant determined by the sample quantile type.

\subsection{Discontinuous sample quantile types 1, 2, and 3}{

  For types 1, 2 and 3, \eqn{Q_i(p)}{Q[i](p)} is a discontinuous
  function of \eqn{p}, with \eqn{m = 0} when \eqn{i = 1} and \eqn{i =
  2}, and \eqn{m = -1/2} when \eqn{i = 3}.

  \describe{
    \item{Type 1}{Inverse of empirical distribution function.
      \eqn{\gamma = 0} if \eqn{g = 0}, and 1 otherwise.}
    \item{Type 2}{Similar to type 1 but with averaging at discontinuities.
      \eqn{\gamma = 0.5} if \eqn{g = 0}, and 1 otherwise (SAS default, see
      \bibcite{Wicklin (2017)}).}
    \item{Type 3}{Nearest even order statistic (SAS default till ca. 2010).
      \eqn{\gamma = 0} if \eqn{g = 0} and \eqn{j} is even,
      and 1 otherwise.}
  }

}
\subsection{Continuous sample quantile types 4 through 9}{

  For types 4 through 9, \eqn{Q_i(p)}{Q[i](p)} is a continuous function
  of \eqn{p}, with \eqn{\gamma = g}{gamma = g} and \eqn{m} given below. The
  sample quantiles can be obtained equivalently by linear interpolation
  between the points \eqn{(p_k,x_k)}{(p[k],x[k])} where \eqn{x_k}{x[k]}
  is the \eqn{k}-th order statistic.  Specific expressions for
  \eqn{p_k}{p[k]} are given below.

  \describe{
    \item{Type 4}{\eqn{m = 0}. \eqn{p_k = \frac{k}{n}}{p[k] = k / n}.
      That is, linear interpolation of the empirical \abbr{cdf}.
    }

    \item{Type 5}{\eqn{m = 1/2}.
      \eqn{p_k = \frac{k - 0.5}{n}}{p[k] = (k - 0.5) / n}.
      That is a piecewise linear function where the knots are the values
      midway through the steps of the empirical \abbr{cdf}.  This is popular
      amongst hydrologists.
    }

    \item{Type 6}{\eqn{m = p}. \eqn{p_k = \frac{k}{n + 1}}{p[k] = k / (n + 1)}.
      Thus \eqn{p_k = \mbox{E}[F(x_{k})]}{p[k] = E[F(x[k])]}.
      This is used by \I{Minitab} and by SPSS.
    }

    \item{Type 7}{\eqn{m = 1-p}.
      \eqn{p_k = \frac{k - 1}{n - 1}}{p[k] = (k - 1) / (n - 1)}.
      In this case, \eqn{p_k = \mbox{mode}[F(x_{k})]}{p[k] = mode[F(x[k])]}.
      This is used by S.
    }

    \item{Type 8}{\eqn{m = (p+1)/3}.
      \eqn{p_k = \frac{k - 1/3}{n + 1/3}}{p[k] = (k - 1/3) / (n + 1/3)}.
      Then \eqn{p_k \approx \mbox{median}[F(x_{k})]}{p[k] =~ median[F(x[k])]}.
      The resulting quantile estimates are approximately median-unbiased
      regardless of the distribution of \code{x}.
    }

    \item{Type 9}{\eqn{m = p/4 + 3/8}.
      \eqn{p_k = \frac{k - 3/8}{n + 1/4}}{p[k] = (k - 3/8) / (n + 1/4)}.
      The resulting quantile estimates are approximately unbiased for
      the expected order statistics if \code{x} is normally distributed.
    }
  }
}

  Further details are provided in \bibcite{Hyndman and Fan (1996)} who
  recommended type 8.
  The default method is type 7, as used by S and by \R < 2.0.0.
  \bibcite{Makkonen and Pajari (2014)} argue for type 6, also as already
  proposed by Weibull in 1939.
  The Wikipedia page contains further information about availability of
  these 9 types in software.
}
\author{
  of the version used in \R >= 2.0.0, Ivan Frohne and Rob J Hyndman;
  tweaks, notably use of \code{fuzz}, by the R Core Team.
}
\references{
  Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
  \emph{The New S Language}.
  Wadsworth & Brooks/Cole.

  Hyndman, R. J. and Fan, Y. (1996) Sample quantiles in statistical
  packages, \emph{American Statistician} \bold{50}, 361--365.
  \doi{10.2307/2684934}.

  Eric Langford (2006)  Quartiles in Elementary Statistics, \emph{Journal
  of Statistics Education} \bold{14} 3; \doi{10.1080/10691898.2006.11910589}

  Makkonen, L. and Pajari, M. (2014)  Defining Sample Quantiles by the True
  Rank Probability, \emph{Journal of Probability and Statistics; Hindawi Publ.Corp.}
  \doi{10.1155/2014/326579}

  Wicklin, R. (2017) Sample quantiles: A comparison of 9 definitions; SAS Blog.
  \url{https://blogs.sas.com/content/iml/2017/05/24/definitions-sample-quantiles.html}

  Wikipedia: \url{https://en.wikipedia.org/wiki/Quantile#Estimating_quantiles_from_a_sample}
}
\seealso{
  \code{\link{ecdf}} for empirical distributions of which
  \code{quantile} is an inverse;
  \code{\link{boxplot.stats}} and \code{\link{fivenum}} for computing
  other versions of quartiles, etc.
}
\examples{
quantile(x <- rnorm(1001)) # Extremes & Quartiles by default
quantile(x,  probs = c(0.1, 0.5, 1, 2, 5, 10, 50, NA)/100)

### Compare different types
quantAll <- function(x, prob, ...)
  t(vapply(1:9, function(typ) quantile(x, probs = prob, type = typ, ...),
           quantile(x, prob, type=1, ...)))
p <- c(0.1, 0.5, 1, 2, 5, 10, 50)/100
signif(quantAll(x, p), 4)

## 0\% and 100\% are equal to min(), max() for all types:
stopifnot(t(quantAll(x, prob=0:1)) == range(x))

## for complex numbers:
z <- complex(real = x, imaginary = -10*x)
signif(quantAll(z, p), 4)
}
\keyword{univar}
