program wiki
implicit none

    type page_hit
        character (256) :: page
        integer :: hits
    end type page_hit

    character (5) :: lang
    character (10) :: hits_str
    character (256) :: page, other
    character (2000) :: line
    character (64) :: fname
    integer :: hits, ios
    integer :: t1, t2, t3, clock_rate
    integer :: idx=1, i, j1, j2, j3, j4
    type(page_hit), dimension(1:1024) :: page_hits

    call system_clock(t1, clock_rate)

    call getarg(1, fname)
    open(10, file=fname)
    do
        read (10, '(A)', iostat=ios) line

        if (ios /= 0) exit

        if (line(1:3) == 'en ') then
            j1 = index(line, ' ')
            lang = line(1:j1)
            j2 = index(line(j1+1:), ' ')
            page = line(j1+1:j1+j2)
            j3 = index(line(j1+j2+1:), ' ')
            read(line(j1+j2+1:j1+j2+j3), *) hits

            if (hits > 500) then
                page_hits(idx)%page = page
                page_hits(idx)%hits = hits
                idx = idx + 1
            end if
        end if
    end do
    close(10)

    call sort(page_hits, idx);

    call system_clock(t2)

    write(*, '(A,F5.2,A)') 'Query took ', real(t2-t1)/real(clock_rate) ,' seconds'

    do i=1, min(10, idx-1)
        write (hits_str, '(I8)') page_hits(i)%hits
        hits_str = adjustl(hits_str)
        write (*, '(A,A,A,A)') trim(page_hits(i)%page), ' (', trim(hits_str), ')';
    end do

contains

    subroutine sort(a, n)
      type(page_hit), intent(in out), dimension(:) :: a
      integer, intent(in) :: n

      type(page_hit) :: temp
      integer :: i, j

      do i = 2, n
         j = i - 1
         temp = a(i)
         DO WHILE (j>=1 .AND. a(j)%hits < temp%hits)
            a(j+1) = a(j)
            j = j - 1
         END DO
         a(j+1) = temp
      END DO
    end subroutine sort

end program wiki
