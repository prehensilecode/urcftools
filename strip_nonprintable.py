#!/usr/bin/env python2
import unicodedata
import re
import sys
import os
import fileinput

### Strips all non-printable characters from stdin
### From: http://stackoverflow.com/a/93029

all_chars = (unichr(i) for i in xrange(0x110000))
#control_chars = ''.join(c for c in all_chars if unicodedata.category(c) == 'Cc')
# or equivalently and much more efficiently
control_chars = ''.join(map(unichr, range(0,32) + range(127,160)))

control_char_re = re.compile('[%s]' % re.escape(control_chars))

if __name__ == '__main__':
    for line in fileinput.input():
        print(control_char_re.sub('', line))

