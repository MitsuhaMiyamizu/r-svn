% File src/library/base/man/source.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2023 R Core Team
% Distributed under GPL 2 or later

\name{source}
\title{Read R Code from a File, a Connection or Expressions}
\alias{source}
\alias{withAutoprint}
\description{
  \code{source} causes \R to accept its input from the named file or URL
  or connection or expressions directly.  Input is read and
  \code{\link{parse}}d from that file
  until the end of the file is reached, then the parsed expressions are
  evaluated sequentially in the chosen environment.

  \code{withAutoprint(exprs)} is a wrapper for \code{source(exprs =
  exprs, ..)} with different defaults.  Its main purpose is to evaluate
  and auto-print expressions as if in a top-level context, e.g, as in the
  \R console.
}
\usage{
source(file, local = FALSE, echo = verbose, print.eval = echo,
       exprs, spaced = use_file,
       verbose = getOption("verbose"),
       prompt.echo = getOption("prompt"),
       max.deparse.length = 150, width.cutoff = 60L,
       deparseCtrl = "showAttributes",
       chdir = FALSE,
       catch.aborts = FALSE,
       encoding = getOption("encoding"),
       continue.echo = getOption("continue"),
       skip.echo = 0, keep.source = getOption("keep.source"))

withAutoprint(exprs, evaluated = FALSE, local = parent.frame(),
              print. = TRUE, echo = TRUE, max.deparse.length = Inf,
              width.cutoff = max(20, getOption("width")),
              deparseCtrl = c("keepInteger", "showAttributes", "keepNA"),
              skip.echo = 0,
              \dots)
}
\arguments{
  \item{file}{a \link{connection} or a character string giving the
    pathname of the file or URL to read from.  The \code{\link{stdin}()}
    connection reads from the console when interactive.}
  \item{local}{\code{TRUE}, \code{FALSE} or an environment, determining
    where the parsed expressions are evaluated.  \code{FALSE} (the
    default) corresponds to the user's workspace (the global
    environment) and \code{TRUE} to the environment from which
    \code{source} is called.}
  \item{echo}{logical; if \code{TRUE}, each expression is printed
    after parsing, before evaluation.}
  \item{print.eval, print.}{logical; if \code{TRUE}, the result of
    \code{eval(i)} is printed for each expression \code{i}; defaults
    to the value of \code{echo}.}
  \item{exprs}{for \code{source()} and \code{withAutoprint(*, evaluated=TRUE)}:
    \emph{instead} of specifying \code{file}, an
    \code{\link{expression}}, \code{\link{call}}, or \code{\link{list}}
    of \code{\link{call}}'s, but \emph{not} an unevaluated \dQuote{expression}.

    for \code{withAutoprint()} (with default \code{evaluated=FALSE}):
    one or more unevaluated \dQuote{expressions}.
  }
  \item{evaluated}{logical indicating that \code{exprs} is passed to
    \code{source(exprs= *)} and hence must be evaluated, i.e., a formal
    \code{expression}, \code{call} or \code{list} of calls.}
  \item{spaced}{logical indicating if newline (hence empty line) should
    be printed before each expression (when \code{echo = TRUE}).}
  \item{verbose}{if \code{TRUE}, more diagnostics (than just
    \code{echo = TRUE}) are printed during parsing and evaluation of
    input, including extra info for \bold{each} expression.}
  \item{prompt.echo}{character; gives the prompt to be used if
    \code{echo = TRUE}.}
  \item{max.deparse.length}{integer; is used only if \code{echo} is
    \code{TRUE} and gives the maximal number of characters output for
    the deparse of a single expression.}
  \item{width.cutoff}{integer, passed to \code{\link{deparse}()} which
    is used (only) when there are no source references.}
  \item{deparseCtrl}{\code{\link{character}} vector, passed as
    \code{control} to \code{\link{deparse}()}, see also
    \code{\link{.deparseOpts}}.  In \R version <= 3.3.x, this was
    hardcoded to \code{"showAttributes"}, which is the default
    currently; \code{deparseCtrl = "all"} may be preferable, when strict
    back compatibility is not of importance.}
  \item{chdir}{logical; if \code{TRUE} and \code{file} is a pathname,
    the \R working directory is temporarily changed to the directory
    containing \code{file} for evaluating.}
  \item{catch.aborts}{logical indicating that \I{\dQuote{abort}ing} errors
    should be caught.}
  \item{encoding}{character vector.  The encoding(s) to be assumed when
    \code{file} is a character string: see \code{\link{file}}.  A
    possible value is \code{"unknown"} when the encoding is guessed: see
    the \sQuote{Encodings} section.}
  \item{continue.echo}{character; gives the prompt to use on
    continuation lines if \code{echo = TRUE}.}
  \item{skip.echo}{integer; how many comment lines at the start of the
    file to skip if \code{echo = TRUE}.}
  \item{keep.source}{logical: should the source formatting be retained
    when echoing expressions, if possible?}
  \item{\dots}{(for \code{withAutoprint()}:) further (non-file related)
    arguments to be passed to \code{source(.)}.}
}
\details{
  Note that running code via \code{source} differs in a few respects
  from entering it at the \R command line.  Since expressions are not
  executed at the top level, auto-printing is not done.  So you will
  need to include explicit \code{print} calls for things you want to be
  printed (and remember that this includes plotting by \CRANpkg{lattice},
  FAQ Q7.22).  Since the complete file is parsed before any of it is
  run, syntax errors result in none of the code being run.  If an error
  occurs in running a syntactically correct script, anything assigned
  into the workspace by code that has been run will be kept (just as
  from the command line), but diagnostic information such as
  \code{\link{traceback}()} will contain additional calls to
  \code{\link{withVisible}}.

  All versions of \R accept input from a connection with end of line
  marked by \abbr{LF} (as used on Unix), \abbr{CRLF} (as used on
  DOS/Windows) or \abbr{CR} (as used on classic Mac OS) and map this to
  newline.  The final line can be incomplete, that is missing the final
  end-of-line marker. 

  If \code{keep.source} is true (the default in interactive use), the
  source of functions is kept so they can be listed exactly as input.

%   Using \code{echo = TRUE} and \code{keep.source = TRUE} may interact
%   badly with source code that includes \samp{#line nn "filename"}
%   directives (e.g., code produced by older versions of
%   \code{\link{Stangle}()}): \code{source()} will attempt to obtain the
%   source from the named file which may have changed since the code was
%   produced.  Use \code{keep.source = FALSE} to avoid this.

  Unlike input from a console, lines in the file or on a connection can
  contain an unlimited number of characters.

  When \code{skip.echo > 0}, that many comment lines at the start of
  the file will not be echoed.  This does not affect the execution of
  the code at all.  If there are executable lines within the first
  \code{skip.echo} lines, echoing will start with the first of them.

  If \code{echo} is true and a deparsed expression exceeds
  \code{max.deparse.length}, that many characters are output followed by
  \code{ .... [TRUNCATED] }.
}
\section{Encodings}{
  By default the input is read and parsed in  the current encoding of
  the \R session.  This is usually what is required, but occasionally
  re-encoding is needed, e.g.\sspace{}if a file from a UTF-8-using system is to
  be read on Windows (or \emph{vice versa}).

  The rest of this paragraph applies if \code{file} is an actual
  filename or URL (and not a connection).  If
  \code{encoding = "unknown"}, an attempt is made to guess the encoding:
  the result of \code{\link{localeToCharset}()} is used as a guide.  If
  \code{encoding} has two or more elements, they are tried in turn until
  the file/URL can be read without error in the trial encoding.  If an
  actual \code{encoding} is specified (rather than the default or
  \code{"unknown"}) in a Latin-1 or UTF-8 locale then character strings
  in the result will be translated to the current encoding and marked as
  such (see \code{\link{Encoding}}).

  If \code{file} is a connection,
  it is not possible to re-encode the input inside \code{source}, and so
  the \code{encoding} argument is just used to mark character strings in the
  parsed input in Latin-1 and UTF-8 locales: see \code{\link{parse}}.
}
\references{
  Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
  \emph{The New S Language}.
  Wadsworth & Brooks/Cole.
}
\seealso{
  \code{\link{demo}} which uses \code{source};
  \code{\link{eval}}, \code{\link{parse}} and \code{\link{scan}};
  \code{\link{options}("keep.source")}.

  \code{\link{sys.source}} which is a streamlined version to source a
  file into an environment.

  \sQuote{The R Language Definition} for a discussion of source
  directives.
}
\examples{
someCond <- 7 > 6
## want an if-clause to behave "as top level" wrt auto-printing :
## (all should look "as if on top level", e.g. non-assignments should print:)
if(someCond) withAutoprint({
   x <- 1:12
   x-1
   (y <- (x-5)^2)
   z <- y
   z - 10
})

## If you want to source() a bunch of files, something like
## the following may be useful:
sourceDir <- function(path, trace = TRUE, ...) {
    op <- options(); on.exit(options(op)) # to reset after each
    for (nm in list.files(path, pattern = "[.][RrSsQq]$")) {
       if(trace) cat(nm,":")
       source(file.path(path, nm), ...)
       if(trace) cat("\n")
       options(op)
    }
}

suppressWarnings( rm(x,y) ) # remove 'x' or 'y' from global env
withAutoprint({ x <- 1:2; cat("x=",x, "\n"); y <- x^2 })
## x and y now exist:
stopifnot(identical(x, 1:2), identical(y, x^2))

withAutoprint({ formals(sourceDir); body(sourceDir) },
              max.deparse.length = 20, verbose = TRUE)
%% --> tests in  ../../../../tests/eval-etc.R

## Continuing after (catchable) errors:
tc <- textConnection('1:3
 2 + "3"
 cat(" .. in spite of error: happily continuing! ..\n")
 6*7')
r <- source(tc, catch.aborts = TRUE)
## Error in 2 + "3" ....
## .. in spite of error: happily continuing! ..
stopifnot(identical(r, list(value = 42, visible=TRUE)))
}
\keyword{file}
\keyword{programming}
\keyword{connection}
