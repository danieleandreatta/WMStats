BINS =

# C binaries
BINS += wiki_fscanf wiki_sscanf wiki_sscanf_precheck wiki_strtok wiki_strtok_precheck wiki_fscanf_sorted wiki_mmap wiki_mmap_opt wiki_mmap_opt_strtok

# C++ binaries
BINS += wiki_fstream_cpp wiki_sstream_cpp wiki_sstream_substr_cpp wiki_sstream_precheck_cpp

# Java
BINS += Wiki_precheck.class Wiki_split.class

# Rust
BINS += wiki_rust

# Haskell
BINS += wiki_hs

# Ocaml
BINS += wiki_precheck_ml  wiki_precheck_regex_ml wiki_split_ml

# F95/F77 
BINS += wiki_f90 wiki_f77

# GO
BINS += wiki_go

all: $(BINS)

wiki_precheck_ml: wiki_precheck_ml.ml
	ocamlopt -o $@ str.cmxa $<
wiki_precheck_regex_ml: wiki_precheck_regex_ml.ml
	ocamlopt -o $@ str.cmxa $<
wiki_split_ml: wiki_split_ml.ml
	ocamlopt -o $@ str.cmxa $<
wiki_fstream_cpp: wiki_fstream_cpp.cpp
	g++ -O1 -std=c++11 -o $@ $<
wiki_sstream_cpp: wiki_sstream_cpp.cpp
	g++ -O1 -std=c++11 -o $@ $<
wiki_sstream_precheck_cpp: wiki_sstream_precheck_cpp.cpp
	g++ -O1 -std=c++11 -o $@ $<
wiki_sstream_substr_cpp: wiki_sstream_substr_cpp.cpp
	g++ -O1 -std=c++11 -o $@ $<
wiki_fscanf: wiki_fscanf.c
	gcc -O1 -o $@ $<
wiki_mmap_opt_strtok: wiki_mmap_opt_strtok.c
	gcc -O1 -o $@ $<
wiki_sscanf: wiki_sscanf.c
	gcc -O1 -o $@ $<
wiki_sscanf_precheck: wiki_sscanf_precheck.c
	gcc -O1 -o $@ $<
wiki_mmap: wiki_mmap.c
	gcc -O1 -o $@ $<
wiki_mmap_opt: wiki_mmap_opt.c
	gcc -O1 -o $@ $<
wiki_strtok: wiki_strtok.c
	gcc -O1 -o $@ $<
wiki_strtok_precheck: wiki_strtok_precheck.c
	gcc -O1 -o $@ $<
wiki_fscanf_sorted: wiki_fscanf_sorted.c
	gcc -O1 -o $@ $<
wiki_rust: wiki_rs.rs
	cargo build --release
	mv target/release/wiki_rust .
wiki_hs: wiki_hs.hs
	ghc -O -o $@ $<
Wiki_precheck.class: Wiki_precheck.java
	javac $<
Wiki_split.class: Wiki_split.java
	javac $<
wiki_f90: wiki_f90.f90
	gfortran -O2 -o $@ $<
wiki_f77: wiki_f77.f
	gfortran -O2 -o $@ $<
wiki_go: wiki_go.go
	go build -o $@ $<
