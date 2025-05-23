#### Test R's (64-bit) date-time functions .. output tested *sloppily*

## R's internal fixes are used on 32-bit platforms.
## macOS gets these wrong: see HAVE_WORKING_64BIT_MKTIME

Sys.setenv(TZ = "UTC")
(z <- as.POSIXct("1848-01-01 12:00"))
c(unclass(z))
(z <- as.POSIXct("2040-01-01 12:00"))
c(unclass(z))
(z <- as.POSIXct("2040-07-01 12:00"))
c(unclass(z))

Sys.setenv(TZ = "Europe/London")  # pretty much portable.
(z <- as.POSIXct("1848-01-01 12:00"))
c(unclass(z))
## We don't know the operation of timezones next year let alone in 2040
## but these should at least round-trip
## These got the wrong timezone on Linux with glibc 2.2[67]
as.POSIXct("2040-01-01 12:00")
as.POSIXct("2040-07-01 12:00")

Sys.setenv(TZ = "EST5EDT")  # also pretty much portable.
## However, tzdata 2024b changed this from EST to LMT (and by 238s)
## IGNORE_RDIFF_BEGIN
(z <- as.POSIXct("1848-01-01 12:00"))
c(unclass(z))
## IGNORE_RDIFF_END
## see comment above
as.POSIXct("2040-01-01 12:00")
as.POSIXct("2040-07-01 12:00")

## PR15613: had day as > 24hrs.
as.POSIXlt(ISOdate(2071,1,13,0,0,tz="Etc/GMT-1"))$wday
as.POSIXlt(ISOdate(2071,1,13,0,1,tz="Etc/GMT-1"))$wday


## Incorrect use of %b should work even though abbreviation does match
Sys.setlocale("LC_TIME", "C") # to be sure
stopifnot(!is.na(strptime("11-August-1903", "%d-%b-%Y")))

## Prior to R 4.0.0 this overflowed an array.  Now gives a warning

z <- paste("2017", c(1,365,366), sep = "-")
(zz <- strptime(z, "%Y-%j"))
stopifnot(identical(is.na(zz), c(FALSE, FALSE, TRUE)))
