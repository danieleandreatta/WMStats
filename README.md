# wiki page stats

These are various implementations [for this challenge](https://gist.github.com/search?q=wmstats)

Multiple language implementations:

Java, C, C++, Go, Bash, gawk/mawk, f77, f90, Perl, Python, Ocaml, Haskell, Lua, Ruby and GNU Smalltalk

## Some Notes on implementations

Multiple approaches for each language. Generally for all languages I make a "read a line and split it" and a 
"read a line, check if it starts with 'en', then split it".

The file names are more or less self explanatory:

- *precheck* - check if the line starts with 'en ' before splitting
- *split* - split the line and check the parts
- *regex* - splitting with regex
- *sscanf/fscanf/strtok* - C version using those functions
- *mmap* - using mmap in C
- *opt* - with mmap, using madvise
- *fstream* - c++ using fstreams with standard `>>` operator
- *sstream* - c++ reading line with getline and extracting data from stringstream
- *substr* - c++ precheck using method `substr()`

### C

These are the fastest versions, but they are the most limited, since there is almost no memory management, and they assume
things will fit in the allocated buffers.

The version with mmap is the fastest, since it checks if the buffer starts with "en " and only then
it copies the line out of the filesystem buffer, i.e. it is the version with the least amount of memory traffic.

### C++

I tried to make a idiomatic c++ version, using `vector`, `string` and other higher level construct, and not using C constructs.

### Java

Just because it has to be there

### Fortran

Fortran 77 does not have many string handling functions, so I had to use `read()` from interal files. Also, because
of these limitations, it is somewhat tricky to get the correct formatting.

Fortran 90 has many more functions to handle strings, so it is somewhat easier.

### Python, Ruby, Perl

The standard scripting languages. I used Perl, Python is the languate I know best right know and Ruby is the one I am using at the moment

### Rust, Go and Lua

Go, Lua and Rust are new languages to me, I just wanted to see what they were like.

### Bash

The "normal" bash version, i.e. using a sequence of piped command (grep/awk/cut/sort/head) performs very well, 
due to the fact that those utilities are fairly optimised and also due to the parallelism that can be achieved 
using piping in shell

The pure bash version was just for fun, to see if it was doable. 

### awk

Both mawk and gawk I tried the same approach as the other versions, i.e. get all the relevant entries, then sort them. gawk has a built-in asort
that can be used, but mawk does not, and I wrote a simple insertion sort for this test. (the speed of the sorting is not a factor here)
This is not an issue even in bash with a custom written bubble sort, but for mawk and gawk, this causes them to start using 
memory until they crash. To work around this, the pure awk version (no GNU extension) scan the list multiple times to find
the largest value, prints it and removes it, then repeat 9 more times.

### Smalltalk

Apart for the lack of documentation, I had the most fun with this. For some reason I enjoy programming in Smalltalk...

### Testing scripts

I have included a few scripts to test the output was as expected. the script `run_test.sh` takes a list of commands and runs them against the
input file (specified in the script itself) and checks if the output is correct. To use different pages, change the hardcoded values in the script.

The script `run_all_tests.sh` runs all tests and outputs a nice tables with times.

There is also a 'short' version for quick checks. I created a sampled file with 1% of the entries as follows:

`awk 'NR%100==0' pagecounts-20141029-230000 > pagecounts_sampled_100`

## Results

All versions read from file passed as command line argument.

Times on a Thinkpad T410i, with 4GB ram and an i3-330M @ 2.13GHz:

Ubuntu 14.04.2 LTS

Languages:
```
C               GCC 4.8.2
C++             GCC 4.8.2
Fortran 77/90   GCC 4.8.2
Haskell         GHC 7.6.3
Ocaml           Ocaml 4.01.0
gawk            GNU awk 4.0.1
mawk            mawk 1.3.3
rust            rust 1.0-alpha1
java            OpenJDK 1.7.0_75
python          2.7.6
python3         3.4.0
perl            5.18.2
ruby            1.9.1
ruby2           2.0.0
Go              1.2.1
bash            4.3.11
lua             5.3.2
smalltalk       GNU Smalltalk 3.2.4
lisp            SBCL 1.1.14
clisp           GNU CLISP 2.49
```

Times:

```
c          ./wiki_mmap_opt_strtok           OK   0.92 
c          ./wiki_strtok_precheck           OK   1.33 
c          ./wiki_strtok                    OK   1.36 
c          ./wiki_mmap_opt                  OK   1.69 
bash       ./wiki.bash                      OK   1.98 
c          ./wiki_sscanf_precheck           OK   2.01 
mawk       ./wiki.mawk                      OK   2.60 
rust       ./wiki_rust                      OK   2.99 
rust_0.12  ./wiki_rust_0.12                 OK   3.06 
java       ./wiki_precheck_java             OK   3.31 
c          ./wiki_fscanf                    OK   3.47 
gawk       ./wiki_asort.gawk                OK   3.66 
gawk       ./wiki.gawk                      OK   3.68 
c          ./wiki_fscanf_sorted             OK   3.79 
c++        ./wiki_fstream_cpp               OK   4.09 
c          ./wiki_sscanf                    OK   4.38 
haskell    ./wiki_hs                        OK   4.42 
c          ./wiki_mmap                      OK   4.52 
c++        ./wiki_sstream_substr_cpp        OK   4.65 
java       ./wiki_split_java                OK   5.63 
ocaml      ./wiki_precheck_ml               OK   6.24 
python     ./wiki_split.py                  OK   6.83 
go         ./wiki_go                        OK   6.94 
python     ./wiki_precheck.py               OK   5.97
python3    ./wiki_precheck_3.py             OK   6.12 
fortran_90 ./wiki_f90                       OK   7.77 
fortran_77 ./wiki_f77                       OK   7.82 
c++        ./wiki_sstream_precheck_cpp      OK   8.10 
python3    ./wiki_split_3.py                OK   8.18 
perl       ./wiki_precheck.pl               OK   8.49 
ruby       ./wiki_precheck.rb               OK   9.26 
c++        ./wiki_sstream_cpp               OK  10.60 
ruby2      ./wiki_precheck_2.rb             OK  11.18 
lisp       ./wiki_lisp_sbcl                 OK  11.18 
ocaml      ./wiki_split_ml                  OK  12.86
ocaml      ./wiki_precheck_regex_ml         OK  13.67 
perl       ./wiki_split.pl                  OK  14.08 
ruby       ./wiki_split.rb                  OK  16.22 
ruby       ./wiki_readlines.rb              OK  19.13 
ruby2      ./wiki_split_2.rb                OK  20.64 
ruby2      ./wiki_readlines_2.rb            OK  20.92 
lua        ./wiki.lua                       OK  37.00 
clisp      ./wiki_lisp_clisp                OK  70.61 
smalltalk  ./wiki_precheck.st               OK  78.84 
smalltalk  ./wiki_precheck_classed.st       OK  81.79 
smalltalk  ./wiki_precheck_regex.st         OK  87.17 
smalltalk  ./wiki_split.st                  OK 111.54 
bash       ./wiki_pure.bash                 OK 128.00 
smalltalk  ./wiki_tokenize.st               OK 170.28 
```

