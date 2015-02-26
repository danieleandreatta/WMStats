(declaim (optimize (speed 3) (space 0) (debug 0)))

(defun split-str (chr string)
  (declare (optimize speed))
  "Returns a list of substrings of string divided by ONE space each.
  Note: Two consecutive spaces will be seen as if there were an empty string between them."
      (loop for i = 0 then (1+ j)
            as j = (position chr string :start i)
            collect (subseq string i j) while j))

(defun take (n lst)
  (declare (fixnum i))
  (cond
    ((null lst) '())
    ((= n 0) '())
    (t (cons (first lst) (take (1- n) (rest lst))))))

#+SBCL  (defparameter +ext-fmt+ :latin-1)
#+CLISP (defparameter +ext-fmt+ (ext:make-encoding :charset 'charset:iso-8859-1 :line-terminator :unix))

(defun read-stats (fname)
  (declare (optimize speed))
  (let ((data '()))
    (with-open-file (stream fname :external-format +ext-fmt+)
      (do ((line (read-line stream nil)
                 (read-line stream nil)))
        ((null line) data)
        (if (string= (subseq line 0 3) "en ")
          (let* ((stats (split-str #\Space line))
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

#+SBCL  (main (second sb-ext:*posix-argv*))
#+CLISP (main (first *args*))


