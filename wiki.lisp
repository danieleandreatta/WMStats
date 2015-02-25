(defun split (chars str &optional (lst nil) (accm ""))
    (cond
          ((= (length str) 0) (reverse (cons accm lst)))
              (t (let ((c (char str 0)))
                    (if (member c chars)
                        (split chars (subseq str 1) (cons accm lst) "")
                        (split chars (subseq str 1) lst 
                            (concatenate 'string accm (string c))))))))

(defun take (n lst)
  (cond
    ((null lst) '())
    ((= n 0) '())
    (t (cons (first lst) (take (1- n) (rest lst))))))

(defun read-stats (fname)
  (let ((data '()))
    (with-open-file (stream fname :external-format :latin-1)
      (do ((line (read-line stream nil)
                 (read-line stream nil)))
        ((null line) data)
        (if (string= (subseq line 0 3) "en ")
          (let* ((stats (split '(#\Space) line))
                 (page-count (parse-integer (third stats))))
            ;(format t "~S ~S ~S ~S~%" (second stats) (third stats) page-count (> page-count 500))
            (if (> page-count 500)
              (push (list (second stats) page-count) data))))))))

(defun main (fname)
  (let* ((t0 (get-internal-real-time))
         (stats (read-stats fname))
         (sorted-stats (sort stats #'> :key #'second)))
    (let ((t1 (get-internal-real-time)))
      (format t "Query took ~,2F seconds~%" (/ (- t1 t0) internal-time-units-per-second))
      (dolist (x (take 10 sorted-stats))
        (format t "~A (~D)~%" (first x) (second x))))))

(main (second sb-ext:*posix-argv*))
