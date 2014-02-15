spugtex
=======

*An irssi plugin for Unicode math notation.*

This plugin replaces LaTeX symbol names with their respective Unicode characters in your outgoing messages.

![alt text](http://www.lofibucket.com/images/spugtex.gif "Logo Title Text 1")

## Usage
`/math <some nice math>`
 Replaces the symbol keywords in your message with Unicode codepoints.

 `/mathp <some nice math>`
 Prints a preview of the message to the current window.

### Examples

     /math Lambda = alpha/omega
     Λ = α/ω

## Installation

 Copy this file to your irssi scripts directory:
  
     $ wget -O ~/.irssi/scripts/spugtex.pl https://raw.github.com/seece/spugtex/master/spugtex.pl 

 and load the script in irssi with

     /script load spugtex.pl 

## On fonts
Not all fonts support the math symbols spugtex outputs. One good choice for a terminal/IRC font is [Deja Vu Mono](http://dejavu-fonts.org/wiki/Main_Page).

## License
MIT License, see `COPYING` for details.





