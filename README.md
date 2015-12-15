# Ebola_Outbreak_Simulation
Simulation of Ebola outbreak with [ReactiveML](http://rml.lri.fr), an extension to OCaml.
The model we used is based on [This Research](http://necsi.edu/research/social/pandemics/beyondcontact.html).

## How to run
1. You need to install [OPAM](https://opam.ocaml.org), a package manager for OCaml
2. Then install ReactiveML in command-line as follows:
```
opam install rml
```
3. Compiling the files by running "make"
4. Finally, run the executable like:
```
./ebola_outbreak.opt
```

If you see some errors regarding Graphics module, [This stackoverflow answer](http://stackoverflow.com/a/29609483) may help you solve the issue.
