% File src/library/grDevices/man/cairo.Rd
% Part of the R package, https://www.R-project.org
% Copyright 1995-2023 R Core Team
% Distributed under GPL 2 or later

\name{cairo}
\alias{svg}
\alias{cairo_pdf}
\alias{cairo_ps}
\title{\I{Cairographics}-based SVG, PDF and PostScript Graphics Devices}
\description{
  Graphics devices for SVG, PDF and PostScript graphics files using
  the \I{cairo} graphics API.
}
\usage{
svg(filename = if(onefile) "Rplots.svg" else "Rplot\%03d.svg",
    width = 7, height = 7, pointsize = 12,
    onefile = FALSE, family = "sans", bg = "white",
    antialias = c("default", "none", "gray", "subpixel"),
    symbolfamily)

cairo_pdf(filename = if(onefile) "Rplots.pdf" else "Rplot\%03d.pdf",
          width = 7, height = 7, pointsize = 12,
          onefile = TRUE, family = "sans", bg = "white",
          antialias = c("default", "none", "gray", "subpixel"),
          fallback_resolution = 300, symbolfamily)

cairo_ps(filename = if(onefile) "Rplots.ps" else "Rplot\%03d.ps",
         width = 7, height = 7, pointsize = 12,
         onefile = TRUE, family = "sans", bg = "white",
         antialias = c("default", "none", "gray", "subpixel"),
         fallback_resolution = 300, symbolfamily)
}
\arguments{
  \item{filename}{the file path of the output file(s).
    The page number is substituted if a C integer format is included in
    the character string, as in the default.  (Depending on the platform,
    the result must be less
    than \code{PATH_MAX} characters long, and may be truncated if not.
    See \code{\link{pdf}} for further details.)  Tilde expansion
    is performed where supported by the platform.}
  \item{width}{the width of the device in inches.}
  \item{height}{the height of the device in inches.}
  \item{pointsize}{the default pointsize of plotted text (in big points).}
  \item{onefile}{should all plots appear in one file or in separate files?}
  \item{family}{one of the device-independent font families,
    \code{"sans"}, \code{"serif"} and \code{"mono"}, or a character
    string specify a font family to be searched for in a
    system-dependent way.

    On unix-alikes (incl.\ macOS), see
    the \sQuote{\I{Cairo} fonts} section in the help for \code{\link{X11}}.
  }
  \item{bg}{the initial background colour: can be overridden by setting
    \code{par("bg")}.}
  \item{antialias}{string, the type of anti-aliasing (if any) to be used;
    defaults to \code{"default"}.}
  \item{fallback_resolution}{numeric: the resolution in dpi used when
    falling back to bitmap output.}
  \item{symbolfamily}{
      a length-one character string that specifies the font family to
      be used as the "symbol" font (e.g., for \link{plotmath} output).}
}
\details{
  SVG (Scalar Vector Graphics) is a W3C standard for vector graphics.
  See \url{https://www.w3.org/Graphics/SVG/}.  The output from
  \code{svg} is SVG version 1.1 for \code{onefile = FALSE} (the
  default), otherwise SVG 1.2.  (SVG 1.2 never passed the draft
  stage. Few SVG viewers are capable of displaying multi-page SVG files,
  and they have been dropped from SVG 2.0 (still in draft).)

  Note that unlike \code{\link{pdf}} and \code{\link{postscript}},
  \code{cairo_pdf} and \code{cairo_ps} sometimes record \emph{bitmaps}
  and not vector graphics.  On the other hand, they can
  (on suitable platforms) include a much wider range of UTF-8 glyphs,
  and embed the fonts used.

  The output produced by \code{cairo_ps(onefile = FALSE)} will be
  encapsulated postscript on a platform with \I{cairo} >= 1.6.

  \R can be compiled without support for any of these devices: this will
  be reported if you attempt to use them on a system where they are not
  supported.

  If you plot more than one page on one of these devices and do not
  include something like \code{\%d} for the sequence number in
  \code{filename} (or set \code{onefile = TRUE}) the file will contain the
  last page plotted.

  There is full support of semi-transparency, but using this is one of
  the things liable to trigger bitmap output (and will always do so for
  \code{cairo_ps}).
}

\note{
  In principle these devices are independent of X11 (as is seen by their
  presence on Windows).  But on a Unix-alike the \I{cairo} libraries may be
  distributed as part of the X11 system and hence that (for example, on
  macOS, \I{XQuartz}) may need to be installed.
}

\value{
  A plot device is opened: nothing is returned to the \R interpreter.
}

\section{Anti-aliasing}{
  Anti-aliasing is applied to both graphics and fonts.  It is generally
  preferable for lines and text, but can lead to undesirable effects for
  fills, e.g.\sspace{}for \code{\link{image}} plots, and so is never used for
  fills.

  \code{antialias = "default"} is in principle platform-dependent, but
  seems most often equivalent to \code{antialias = "gray"}.
}

\section{Conventions}{
  This section describes the implementation of the conventions for
  graphics devices set out in the \sQuote{R Internals} manual.

  \itemize{
    \item The default device size is in pixels (\code{svg}) or inches.
    \item Font sizes are in big points.
    \item The default font family is Helvetica.
    \item Line widths are multiples of 1/96 inch.
    \item Circle radii have a minimum of 1/72 inch.
    \item Colours are interpreted by the viewing application.
  }
}

\section{Warning}{
  Support for all these devices are optional, so in packages they should
  be used conditionally after checking \code{\link{capabilities}("cairo")}.
}

\seealso{
  \code{\link{Devices}}, \code{\link{dev.print}}, \code{\link{pdf}},
  \code{\link{postscript}}

  \code{\link{capabilities}} to see if \I{cairo} is supported.
}

\keyword{device}
