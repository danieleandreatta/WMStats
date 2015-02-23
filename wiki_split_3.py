#!/usr/bin/python3.4

import time
import sys

t0 = time.clock()

pages = []

with open(sys.argv[1], 'rb') as f:
  for line in f:
      ws = line.split()
      if ws[0] == b'en' and int(ws[2]) > 500:
          pages.append((ws[1].decode('ascii'), int(ws[2])))

pages.sort(reverse=True, key=lambda x:x[1])

t1 = time.clock()

print('Query took %.2f seconds' % (t1-t0))

for i in range(min(10, len(pages))):
    print('%s (%d)' % pages[i])
