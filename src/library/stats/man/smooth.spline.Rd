% File src/library/stats/man/smooth.spline.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2024 R Core Team
% Distributed under GPL 2 or later

\name{smooth.spline}
\alias{smooth.spline}
\alias{.nknots.smspl}
%\alias{print.smooth.spline}% is not exported
%\alias{hatvalues.smooth.spline}% is not exported
\title{Fit a Smoothing Spline}
\description{
  Fits a cubic smoothing spline to the supplied data.
}
\usage{
smooth.spline(x, y = NULL, w = NULL, df, spar = NULL, lambda = NULL, cv = FALSE,
              all.knots = FALSE, nknots = .nknots.smspl,
              keep.data = TRUE, df.offset = 0, penalty = 1,
              control.spar = list(), tol = 1e-6 * IQR(x), keep.stuff = FALSE)

.nknots.smspl(n)
}
\arguments{
 \item{x}{a vector giving the values of the predictor variable, or  a
   list or a two-column matrix specifying x and y. }
 \item{y}{responses. If \code{y} is missing or \code{NULL}, the responses
   are assumed to be specified by \code{x}, with \code{x} the index
   vector.}
 \item{w}{optional vector of weights of the same length as \code{x};
   defaults to all 1.}
 \item{df}{the desired equivalent number of degrees of freedom (trace of
   the smoother matrix).  Must be in \eqn{(1,n_x]}{(1,nx]},
   \eqn{n_x}{nx} the number of unique x values, see below.}
 \item{spar}{smoothing parameter, typically (but not necessarily) in
   \eqn{(0,1]}.  When \code{spar} is specified, the coefficient
   \eqn{\lambda} of the integral of the squared second derivative in the
   fit (penalized log likelihood) criterion is a monotone function of
   \code{spar}, see the details below.  Alternatively \code{lambda} may
   be specified instead of the \emph{scale free} \code{spar}=\eqn{s}.}
 \item{lambda}{if desired, the internal (design-dependent) smoothing
   parameter \eqn{\lambda} can be specified instead of \code{spar}.
   This may be desirable for resampling algorithms such as cross
   validation or the bootstrap.}
 \item{cv}{ordinary leave-one-out (\code{TRUE}) or \sQuote{generalized}
   cross-validation (GCV) when \code{FALSE}; is used for smoothing
   parameter computation only when both \code{spar} and \code{df} are
   not specified; it is used however to determine \code{cv.crit} in the
   result.  Setting it to \code{NA} for speedup skips the evaluation of
   leverages and any score.}
 \item{all.knots}{if \code{TRUE}, all distinct points in \code{x} are used
   as knots.  If \code{FALSE} (default), a subset of \code{x[]} is used,
   specifically \code{x[j]} where the \code{nknots} indices are evenly
   spaced in \code{1:n}, see also the next argument \code{nknots}.

   Alternatively, a strictly increasing \code{\link{numeric}} vector
   specifying \dQuote{all the knots} to be used; must be rescaled
   to \eqn{[0, 1]} already such that it corresponds to the
   \code{ans $ fit$knots} sequence returned, not repeating the boundary
   knots.}
 \item{nknots}{integer or \code{\link{function}} giving the number of
   knots to use when \code{all.knots = FALSE}.  If a function (as by
   default), the number of knots is \code{nknots(nx)}.  By default using
   \code{.nknots.smspl()}, for
   \eqn{n_x > 49}{nx > 49} this is less than \eqn{n_x}{nx}, the number
   of unique \code{x} values, see the Note.}
 \item{keep.data}{logical specifying if the input data should be kept
   in the result.  If \code{TRUE} (as per default), fitted values and
   residuals are available from the result.}
 \item{df.offset}{allows the degrees of freedom to be increased by
   \code{df.offset} in the GCV criterion.}
 \item{penalty}{the coefficient of the penalty for degrees of freedom
   in the GCV criterion.}

 \item{control.spar}{optional list with named components controlling the
   root finding when the smoothing parameter \code{spar} is computed,
   i.e., missing or \code{NULL}, see below.

   \bold{Note} that this is partly \emph{experimental} and may change
   with general spar computation improvements!

   \describe{
     \item{low:}{lower bound for \code{spar}; defaults to -1.5 (used to
       implicitly default to 0 in \R versions earlier than 1.4).}
     \item{high:}{upper bound for \code{spar}; defaults to +1.5.}
     \item{tol:}{the absolute precision (\bold{tol}erance) used; defaults
     to 1e-4 (formerly 1e-3).}
     \item{eps:}{the relative precision used; defaults to 2e-8 (formerly
       0.00244).}
     \item{trace:}{logical indicating if iterations should be traced.}
     \item{maxit:}{integer giving the maximal number of iterations;
       defaults to 500.}
   }
   Note that \code{spar} is only searched for in the interval
   \eqn{[low, high]}.
 }

 \item{tol}{a tolerance for sameness or uniqueness of the \code{x}
   values.  The values are binned into bins of size \code{tol} and
   values which fall into the same bin are regarded as the same.  Must
   be strictly positive (and finite).}
 \item{keep.stuff}{an experimental \code{\link{logical}} indicating if
   the result should keep extras from the internal computations.  Should
   allow to reconstruct the \eqn{X} matrix and more.}

 \item{n}{for \code{.nknots.smspl}; typically the number of unique
   \code{x} values (aka \eqn{n_x}{nx}).}
}
\details{
  Neither \code{x} nor \code{y} are allowed to containing missing or
  infinite values.

  The \code{x} vector should contain at least four distinct values.
  \sQuote{Distinct} here is controlled by \code{tol}: values which are
  regarded as the same are replaced by the first of their values and the
  corresponding \code{y} and \code{w} are pooled accordingly.

  Unless \code{lambda} has been specified instead of \code{spar},
  the computational \eqn{\lambda} used (as a function of
  \eqn{s=spar}{\code{spar}}) is
  \eqn{\lambda = r \cdot 256^{3 s - 1}}{\lambda = r * 256^(3*spar - 1)}
  where
  \eqn{r = tr(X' W X) / tr(\Sigma)},
  \eqn{\Sigma} is the matrix given by
  \eqn{\Sigma_{ij} = \int B_i''(t) B_j''(t) dt}{\Sigma[i,j] = Integral B''[i](t) B''[j](t) dt},
  \eqn{X} is given by \eqn{X_{ij} = B_j(x_i)}{X[i,j] = B[j](x[i])},
  \eqn{W} is the diagonal matrix of weights (scaled such that
  its trace is \eqn{n}, the original number of observations)
  and \eqn{B_k(.)}{B[k](.)} is the \eqn{k}-th B-spline.

  Note that with these definitions, \eqn{f_i = f(x_i)}, and the B-spline
  basis representation \eqn{f = X c} (i.e., \eqn{c} is
  the vector of spline coefficients), the penalized log likelihood is
  \eqn{L = (y - f)' W (y - f) + \lambda c' \Sigma c}, and hence
  \eqn{c} is the solution of the (ridge regression)
  \eqn{(X' W X + \lambda \Sigma) c = X' W y}.

  If \code{spar} and \code{lambda} are missing or \code{NULL}, the value
  of \code{df} is used to determine the degree of smoothing.  If
  \code{df} is missing as well, leave-one-out cross-validation (ordinary
  or \sQuote{generalized} as determined by \code{cv}) is used to
  determine \eqn{\lambda}.

%%  lam      = r * 256^(3s - 1)
%%  log(lam) = log(r) + (3s - 1) * log(256)
%% (log(lam) - log(r)) / log(256)  = 3s - 1
%% s = [1 +  {log(lam) - log(r)} / {8 log(2)} ] / 3
%%   = 1/3 + {log(lam) - log(r)} / {24 log(2)}
%%   = 1/3 - log(r)/{24 log(2)} +  log(lam) / {24 log(2)}
%%   =               s0         + 0.0601 * log(lam)
  Note that from the above relation,
  \code{spar} is \eqn{s = s0 + 0.0601 \cdot \log\lambda}{spar = s0 + 0.0601 * log(\lambda)}.
  %% which is intentionally \emph{different} from the S-PLUS implementation
  %% of \code{smooth.spline} (where \code{spar} is proportional to
  %% \eqn{\lambda}).
  %% In \R's (\eqn{\log \lambda}{log \lambda}) scale, it makes more
  %% sense to vary \code{spar} linearly.

  Note however that currently the results may become very unreliable
  for \code{spar} values smaller than about -1 or -2.  The same may
  happen for values larger than 2 or so.  Don't think of setting
  \code{spar} or the controls \code{low} and \code{high} outside such a
  safe range, unless you know what you are doing!
  Similarly, specifying \code{lambda} instead of \code{spar} is
  delicate, notably as the range of \dQuote{safe} values for
  \code{lambda} is not scale-invariant and hence entirely data dependent.

  The \sQuote{generalized} cross-validation method GCV will work correctly when
  there are duplicated points in \code{x}.  However, it is ambiguous what
  leave-one-out cross-validation means with duplicated points, and the
  internal code uses an approximation that involves leaving out groups
  of duplicated points.  \code{cv = TRUE} is best avoided in that case.
}
\note{
  The number of unique \code{x} values, \eqn{\code{nx} = n_x}{nx}, are
  determined by the \code{tol} argument, equivalently to
  \preformatted{
    nx <- length(x) - sum(duplicated( round((x - mean(x)) / tol) ))
  }

  The default \code{all.knots = FALSE} and \code{nknots = .nknots.smspl},
  entails using only \eqn{O({n_x}^{0.2})}{O(nx ^ 0.2)}
  knots instead of \eqn{n_x}{nx} for \eqn{n_x > 49}{nx > 49}.  This cuts
  speed and memory requirements, but not drastically anymore since \R
  version 1.5.1 where it is only \eqn{O(n_k) + O(n)}{O(nk) + O(n)} where
  \eqn{n_k}{nk} is the number of knots.

  In this case where not all unique \code{x} values are
  used as knots, the result is a \emph{regression spline} rather than a
  smoothing spline in the strict
  sense, but very close unless a small smoothing parameter (or large
  \code{df}) is used.
}
\value{
  An object of class \code{"smooth.spline"} with components
  \item{x}{the \emph{distinct} \code{x} values in increasing order, see
  the \sQuote{Details} above.}
  \item{y}{the fitted values corresponding to \code{x}.}
  \item{w}{the weights used at the unique values of \code{x}.}
  \item{yin}{the y values used at the unique \code{y} values.}
  \item{tol}{the \code{tol} argument (whose default depends on \code{x}).}
  \item{data}{only if \code{keep.data = TRUE}: itself a
    \code{\link{list}} with components \code{x}, \code{y} and \code{w}
    of the same length.  These are the original \eqn{(x_i,y_i,w_i),
      i = 1, \dots, n}, values where \code{data$x} may have repeated values and
    hence be longer than the above \code{x} component; see details.
    }
  \item{n}{an integer; the (original) sample size.}
  \item{lev}{(when \code{cv} was not \code{NA}) leverages, the diagonal
    values of the smoother matrix.}
  \item{cv}{the \code{cv} argument used; i.e., \code{FALSE}, \code{TRUE}, or \code{NA}.}
  \item{cv.crit}{cross-validation score, \sQuote{generalized} or true, depending
    on \code{cv}.  The CV score is often called \dQuote{PRESS} (and
    labeled on \code{\link{print}()}), for
    \I{\sQuote{\bold{PRE}diction \bold{S}um of \bold{S}quares}}.
    Note that this is \emph{not} the same
    as the (CV or GCV) score which is minimized during fitting (and
    returned in \code{crit}), e.g., in the case of \code{nx < n} (where
    \code{nx}\eqn{=n_x}{=nx} is the number of unique x values).}
  \item{pen.crit}{the penalized criterion, a non-negative number; simply
    the (weighted) residual sum of squares (RSS), \code{ sum(.$w * residuals(.)^2) }.}
  \item{crit}{the criterion value minimized in the underlying
    \code{.Fortran} routine \file{sslvrg}.  When \code{df} has been specified,
    the criterion is \eqn{3 + (tr(S_\lambda) - df)^2}{3 + (tr(S[lambda]) - df)^2},
    where the \eqn{3 +} is there for numerical (and historical) reasons.}
  \item{df}{equivalent degrees of freedom used.  Note that (currently)
    this value may become quite imprecise when the true \code{df} is
    between and 1 and 2.
  }
  \item{spar}{the value of \code{spar} computed or given, unless it has been
    given as \code{c(lambda = *)}, when it set to \code{NA} here.}
  \item{ratio}{(when \code{spar} above is not \code{NA}), the value
    \eqn{r}, the ratio of two matrix traces.}
  \item{lambda}{the value of \eqn{\lambda} corresponding to \code{spar},
    see the details above.}
  \item{iparms}{named integer(3) vector where \code{..$ipars["iter"]}
    gives number of spar computing iterations used.}
  \item{auxMat}{experimental; when \code{keep.stuff} was true, a
    \dQuote{flat} numeric vector containing parts of the internal computations.}
  \item{fit}{list for use by \code{\link{predict.smooth.spline}}, with
    components
    \describe{
      \item{knot:}{the knot sequence (including the repeated boundary
        knots), scaled into \eqn{[0, 1]} (via \code{min} and
	\code{range}).}
      \item{nk:}{number of coefficients or number of \sQuote{proper}
        knots plus 2.}
      \item{coef:}{coefficients for the spline basis used.}
      \item{min, range:}{numbers giving the corresponding quantities of
        \code{x}.}
    }
  }
  \item{call}{the matched call.}

  \code{method(class = "smooth.spline")} shows a
  \code{\link{hatvalues}()} method based on the \code{lev} vector above.
}
\references{
  Chambers, J. M. and Hastie, T. J. (1992)
  \emph{Statistical Models in S}, Wadsworth & Brooks/Cole.

  Green, P. J. and Silverman, B. W. (1994)
  \emph{Nonparametric Regression and Generalized Linear Models:
    A Roughness Penalty Approach.} Chapman and Hall.

  Hastie, T. J. and Tibshirani, R. J. (1990)
  \emph{Generalized Additive Models.}  Chapman and Hall.
}
\author{
  \R implementation by B. D. Ripley and Martin Maechler
  (\code{spar/lambda}, etc).
}
\source{
  This function is based on code in the \code{GAMFIT} Fortran program by
  T. Hastie and R. Tibshirani (originally taken from
  \url{https://lib.stat.cmu.edu/general/gamfit})
   which makes use of spline code by Finbarr O'Sullivan.  Its design
  parallels the \code{smooth.spline} function of Chambers & Hastie (1992).
}
\seealso{
  \code{\link{predict.smooth.spline}} for evaluating the spline
  and its derivatives.
}
\examples{
require(graphics)
plot(dist ~ speed, data = cars, main = "data(cars)  &  smoothing splines")
cars.spl <- with(cars, smooth.spline(speed, dist))
cars.spl
## This example has duplicate points, so avoid cv = TRUE
\dontshow{
  stopifnot(cars.spl $ w == table(cars$speed)) # weights = multiplicities
  utils::str(cars.spl, digits.d = 5, vec.len = 6)
  cars.spl$fit
}
lines(cars.spl, col = "blue")
ss10 <- smooth.spline(cars[,"speed"], cars[,"dist"], df = 10)
lines(ss10, lty = 2, col = "red")
legend(5,120,c(paste("default [C.V.] => df =",round(cars.spl$df,1)),
               "s( * , df = 10)"), col = c("blue","red"), lty = 1:2,
       bg = 'bisque')


## Residual (Tukey Anscombe) plot:
plot(residuals(cars.spl) ~ fitted(cars.spl))
abline(h = 0, col = "gray")

## consistency check:
stopifnot(all.equal(cars$dist,
                    fitted(cars.spl) + residuals(cars.spl)))
## The chosen inner knots in original x-scale :
with(cars.spl$fit, min + range * knot[-c(1:3, nk+1 +1:3)]) # == unique(cars$speed)

## Visualize the behavior of  .nknots.smspl()
nKnots <- Vectorize(.nknots.smspl) ; c.. <- adjustcolor("gray20",.5)
curve(nKnots, 1, 250, n=250)
abline(0,1, lty=2, col=c..); text(90,90,"y = x", col=c.., adj=-.25)
abline(h=100,lty=2); abline(v=200, lty=2)

n <- c(1:799, seq(800, 3490, by=10), seq(3500, 10000, by = 50))
plot(n, nKnots(n), type="l", main = "Vectorize(.nknots.smspl) (n)")
abline(0,1, lty=2, col=c..); text(180,180,"y = x", col=c..)
n0 <- c(50, 200, 800, 3200); c0 <- adjustcolor("blue3", .5)
lines(n0, nKnots(n0), type="h", col=c0)
axis(1, at=n0, line=-2, col.ticks=c0, col=NA, col.axis=c0)
axis(4, at=.nknots.smspl(10000), line=-.5, col=c..,col.axis=c.., las=1)

##-- artificial example
y18 <- c(1:3, 5, 4, 7:3, 2*(2:5), rep(10, 4))
xx  <- seq(1, length(y18), length.out = 201)
(s2   <- smooth.spline(y18)) # GCV
(s02  <- smooth.spline(y18, spar = 0.2))
(s02. <- smooth.spline(y18, spar = 0.2, cv = NA))
plot(y18, main = deparse(s2$call), col.main = 2)
lines(s2, col = "gray"); lines(predict(s2, xx), col = 2)
lines(predict(s02, xx), col = 3); mtext(deparse(s02$call), col = 3)

## Specifying 'lambda' instead of usual spar :
(s2. <- smooth.spline(y18, lambda = s2$lambda, tol = s2$tol))

\dontshow{
stopifnot(identical(
    with(s2$fit, min + range * knot[-c(1:3, nk+1+1:3)]),
    as.numeric(1:18)),
    with(cars.spl$fit, min + range * knot[-c(1:3, nk+1+1:3)]) == unique(cars$speed))

nD <- c("spar", "ratio", "iparms", "call"); nn <- setdiff(names(s2), nD)
stopifnot(all.equal(s2[nn], s2.[nn], tolerance = 7e-7), # seen 6.86e-8
          all.equal(predict(s02 , xx),
		    predict(s02., xx), tolerance = 1e-15))
}
\donttest{
## The following shows the problematic behavior of 'spar' searching:
(s2  <- smooth.spline(y18, control =
                      list(trace = TRUE, tol = 1e-6, low = -1.5)))
(s2m <- smooth.spline(y18, cv = TRUE, control =
                      list(trace = TRUE, tol = 1e-6, low = -1.5)))
## both above do quite similarly (Df = 8.5 +- 0.2)
}}
\keyword{smooth}
