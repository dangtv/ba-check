# Constructing intersection of two Büchi automata, checking emptiness of Büchi automata

## Installation

* Dependencies:
  * OCaml >= 4.06.1: [Installation guide](https://ocaml.org/docs/install.html#Ubuntu)
  * ocamlyacc >= 4.02.1: opam install ocamlyacc
  * ocamllex >= 4.02.1: opam install ocamllex
  * findlib (>= 1.3.1)
  * GNU Make >= 3.81 

* Installing:
  * Clean:
    ```bash
        make clean
    ```
  * Build:
    ```bash
        make all
    ```

## Usage

### Syntax for writing an automaton

```bnf
<automaton>  ::= <trans> <inits> <acceptings>
<trans>      ::= {<state> <alpha> "->" <state>}
<inits>      ::= "S0:" {<state>}
<acceptings> ::= "F:"  {<state>}
<state>      ::= <alpha> (<alpha> | <digit>)+
<alpha>      ::= 'a'|..|'z'|'A'|..|'Z'|'_'
<digit>      ::= '0'|..|'9'
```

### Checking

* Given two Büchi automata A1 and A2, run the binary file `./bin/checkba` to check the emptiness of Lω(A1) ∩ Lω(A1):

    ```bash
    usage: bin/checkba [OPTIONS]
    -f1 filename     : source file of the first automaton (default: "input1.txt")
    -f2 filename     : source file of the second automaton (default: "input2.txt")
    -o filename     : output file for visulazation of the constructed intersection Büchi automaton (default: none)
    -help  Display this list of options
    --help  Display this list of options
    ```

* Visualizing the output file: The output file is a .dot file, which can be visulized by [graphviz](https://graphviz.gitlab.io), see (https://graphviz.gitlab.io/download/) to learn how to install graphviz. Two convert this .dot file to png:

    ```bash
        dot -Tpng dot_file_name > file_name.png
    ```

### Example

* Example 1:

```bash
        bin/checkba -f1 sample/mytest1.txt -f2 sample/mytest2.txt -o sample/mytest12.dot
        dot -Tpng sample/mytest12.dot > sample/mytest12.png
```

* Example 2:

```bash
        bin/checkba -f1 sample/empty1.txt -f2 sample/empty2.txt -o sample/empty12.dot
        dot -Tpng sample/empty12.dot > sample/empty12.png
```

* Example 3:

```bash
        bin/checkba -f1 sample/nonempty1.txt -f2 sample/nonempty2.txt -o sample/nonempty12.dot
        dot -Tpng sample/nonempty12.dot > sample/nonempty12.png
```

* Example 4:

```bash
        bin/checkba -f1 sample/nonempty1.txt -f2 sample/nonempty3.txt -o sample/nonempty13.dot
        dot -Tpng sample/nonempty13.dot > sample/nonempty13.png
```

* Example 5:

```bash
        bin/checkba -f1 sample/empty1.txt -f2 sample/nonempty1.txt -o sample/empty1_nonempty1.dot
        dot -Tpng sample/empty1_nonempty1.dot > sample/empty1_nonempty1.png
```