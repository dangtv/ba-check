# Given two Buchi automata A1 and A2, decide if Lω(A1) ∩ Lω(A2) is empty or not

## Installation

* Dependencies:
  * OCaml >= 4.06.1: [Installation guidance](https://ocaml.org/docs/install.html)
  * GNU Make >= 3.81 

* Compilation:
  * Clean:
    ```bash
        make clean
    ```
  * Build (the built executable file is ./bin/checkba):
    ```bash
        make all
    ```

## Usage

### Syntax for writing an automaton

```text
<automaton>  ::= <trans> <inits> <acceptings>
<trans>      ::= {<state> <alpha> "->" <state>}
<inits>      ::= "S0:" {<state>}
<acceptings> ::= "F:"  {<state>}
<state>      ::= <alpha> (<alpha> | <digit>)+
<alpha>      ::= 'a'|..|'z'|'A'|..|'Z'|'_'
<digit>      ::= '0'|..|'9'
```

### Checking

* Given two Büchi automata A1 and A2, run the binary file `./bin/checkba` to check the emptiness of Lω(A1) ∩ Lω(A2):

    ```bash
    usage: bin/checkba [OPTIONS]
    -f1 filename     : source file of the first automaton (default: "input1.txt")
    -f2 filename     : source file of the second automaton (default: "input2.txt")
    -o filename     : output file for visulazation of the constructed intersection Büchi automaton (default: none)
    -help  Display this list of options
    --help  Display this list of options
    ```
* A message will be printed to tell if Lω(A1) ∩ Lω(A2) is empty or not

* The output file is a visulazation of the constructed Büchi automaton. In this file, the red path shows the lasso of the buchi automaton.
  * The output file has a format of .dot, which can be visulized by [graphviz](https://graphviz.gitlab.io), see (https://graphviz.gitlab.io/download/) to learn how to install graphviz.
  * Graphviz can convert a .dot file to a .png file by using this command:

    ```bash
        dot -Tpng dot_file_name > file_name.png
    ```
  

### Examples

* Example 1:

```bash
        bin/checkba -f1 sample/test1.txt -f2 sample/test2.txt -o sample/test12.dot
        dot -Tpng sample/test12.dot > sample/test12.png
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