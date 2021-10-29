# proofs
Proofs written in Coq for the core katydid validation algorithm

![Check Proofs](https://github.com/awalterschulze/regex-reexamined-coq/workflows/Check%20Proofs/badge.svg)

## Setup

1. Install Coq 8.13.0
2. Remember to set coq in your PATH. For example, in your `~/.bash_profile` add `PATH="/Applications/CoqIDE_8.13.0.app/Contents/Resources/bin/:${PATH}"` and run `$ source ~/.bash_profile`.
3. Run make in this folder.

Note:

 - `make cleanall` cleans all files even `.aux` files.

## Contributing

Please read the [contributing guidelines](https://github.com/awalterschulze/regex-reexamined-coq/blob/master/CONTRIBUTING.md).  They are short and shouldn't be surprising.

## Regenerate Makefile

Coq version upgrade requires regenerating the Makefile with the following command:

```
$ coq_makefile -f _CoqProject -o Makefile
```

## Pair Programming

We have pair programming session on some Saturdays 14:00 - 17:00 UK time.
Please email [Walter](https://github.com/awalterschulze) if you would like to join us.
It would be helpful to understand how to use Coq's Inductive Predicates, but more advanced knowledge is not required.
