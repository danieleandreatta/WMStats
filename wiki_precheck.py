#!/usr/bin/python

import time
import sys

t0 = time.clock()

pages = []

with open(sys.argv[1], 'r') as f:
  for line in f:
      if line.startswith('en '):
          ws = line.split()
          if int(ws[2]) > 500:
              pages.append((ws[1], int(ws[2])))

pages.sort(reverse=True, key=lambda x:x[1])

t1 = time.clock()

print 'Query took %.2f seconds' % (t1-t0)

for i in range(min(10, len(pages))):
    print '%s (%d)' % pages[i]
