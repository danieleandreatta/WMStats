      subroutine sort(a, b, n)
      character*(*) a(*)
      integer b(*)
      integer n

      character*256 temp_a
      integer temp_b

      integer i,j

      do i = 2, n

       j = i - 1
       temp_a = a(i)
       temp_b = b(i)

       do while (j>=1 .and. b(j) < temp_b)
        a(j+1) = a(j)
        b(j+1) = b(j)
        j = j - 1
       end do
       a(j+1) = temp_a
       b(j+1) = temp_b
      end do
      end

      program wiki
      implicit none

      character*2000 line
      character*256 page 
      character*8 hits_str
      character*64 fname
      integer hits, ios
      integer idx, i, j1, j2
      character*256 page_names(1024)
      integer page_hits(1024)
      real t(2), tt1, tt2

      call etime(t, tt1)

      call getarg(1, fname)

      open(10, file=fname)
      idx = 1

10    continue
        read (10, '(A)', iostat=ios) line

        if (ios .ne. 0) goto 20

        if (line(1:3) .eq. 'en ') then
          j1 = index(line(4:), ' ')
          page = line(4:j1+4)
          j2 = index(line(j1+4:), ' ')
          read(line(j1+4:j1+j2+4), *) hits

          if (hits > 500) then
            page_names(idx) = page
            page_hits(idx) = hits
            idx = idx + 1
          end if
        end if

      goto 10
20    continue

      close(10)
      idx = idx - 1

      call sort(page_names, page_hits, idx)

      call etime(t, tt2)

      print '(A,X,F6.2,X,A)', 'Query took', tt2-tt1, 'seconds'

      do i=1, min(10, idx)
        j1 = index(page_names(i), ' ') - 1
        write(hits_str, '(I8)') page_hits(i)
        j2=1
30      if (hits_str(j2:j2) .ne. ' ') goto 40
          j2 = j2 + 1
          goto 30
40      continue
        print '(A,A,A,A)', page_names(i)(1:j1), ' (', hits_str(j2:), ')'
      end do
      end
