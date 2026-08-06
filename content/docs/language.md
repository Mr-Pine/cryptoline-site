---
title: "Language"
weight: 2
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

{{< katex />}}
{{< cl_macro >}}

## Introduction

\\(\cryptoline\\) is a tool and a language for the verification of low-level
implementations of mathematical constructs.
In \\(\cryptoline\\), users can specify two kinds of properties,
namely algebraic properties and range properties.
Algebraic properties involve equalities and modular equalities in the
integer domain while range properties involve bit-accurate variable
ranges.
\\(\cryptoline\\) verifies algebraic properties and range properties
separately.
Verification of algebraic properties is reduced to ideal membership
queries which are solved by external computer algebra systems.
Verification of range properties is reduced to Satisfiability Modulo
Theories (SMT) queries which are solved by external SMT solvers.

## \\(\cryptoline\\) Language

An *identifier* is a regular string started by a letter or an
underscore, followed by letters, digits, or underscores.
\\[
\id ::= (\letter \mid \underscore) [ \letter \mid \digit \mid \underscore ]
\\]

All constants and variables in \\(\cryptoline\\) are typed.
Let \\(w\\) be a positive integer.
\\(\uint w\\) and \\(\sint w\\) in \\(\cryptoline\\) denote the types of bit-vectors
with width \\(w\\) in the unsigned and two's complement signed
representations respectively.
The type \\(\uint 1\\) is also written as \\(\bit\\).
\\[
  \begin{array}{rcl}
    \typ & ::= & \uint 1 \mid \sint 2 \mid \uint 2 \mid \sint 3 \mid
                \cdots \mid \uint w \mid \sint (w+1)
  \end{array}
\\]

These are the types of scalar values.
\\(\cryptoline\\) additionally has vector types, which are described in
[Vectors](#vectors) below.

A *constant* is an integer, a binary number, a hexadecimal
number, a named constant, or arithmetic expressions over constants.

\\[
  \begin{array}{rcl}
    \const &  ::= & \simpleconst \\\\
           & \mid & \pmb(\ \complexconst\ \pmb) \\\\
    \simpleconst &  ::= & \mZ \\\\
           & \mid & 0b[0-1]^+ \\\\
           & \mid & 0x[0-9a-fA-F]^+ \\\\
           & \mid & \pmb\derefop \id \\\\
    \complexconst &  ::= & \const \\\\
           & \mid & \pmb\minusop\ \complexconst \\\\
           & \mid & \complexconst\ \pmb\addop\ \complexconst \\\\
           & \mid & \complexconst\ \pmb\subop\ \complexconst \\\\
           & \mid & \complexconst\ \pmb\mulop\ \complexconst \\\\
           & \mid & \complexconst\ \pmb\powop\ \complexconst \\\\
    \tconst & ::= & \const @ \typ \\\\
           & \mid &  \typ\ \const
  \end{array}
\\]

The value of a named integer \\(c\\) is read by \\(\\$c\\).
\\(\cryptoline\\) supports the following arithmetic operators over
constants: unary minus (-), addition (+), subtraction (-),
multiplication (*), and exponent (**).
A *typed constant* is a constant with its type explicitly
specified.

A *variable* is an identity.
A *typed variable* is a variable with its type explicitly
specified.
An \\(\lval\\) is either a variable or a typed variable.

\\[
  \begin{array}{rcl}
    \var & ::= & \id \\\\
    \tvar & ::= & \var @ \typ \mid \typ\ \var \\\\
    \lval & ::= & \var \mid \tvar
  \end{array}
\\]

The notation \\(t_{\circ}^*\\) and \\(t_{\circ}^+\\) respectlvey represents a
possibly empty and a non-empty sequence of \\(\circ\\)-separated \\(t\\).

An *atom* is either a typed constant, a variable, or a typed
variable.
It is not necessary to specify the variable type explicitly in
an atom because \\(\cryptoline\\) can infer the type automatically.
\\[
\atom ::= \tconst \mid \var \mid \tvar
\\]

An *algebraic expression* is evaluated over \\(\mZ\\).
\\[
\begin{array}{rclcl}
\eexp &  ::= & \simpleconst %\\\\
      & \mid & \var \\\\
      & \mid & \pmb{-}\ \eexp %\\\\
      & \mid & \eexp\ \pmb{+}\ \eexp \\\\
      & \mid & \eexp\ \pmb{-}\ \eexp %\\\\
      & \mid & \eexp\ \pmb{*}\ \eexp \\\\
      & \mid & \eexp\ \pmb{**}\ \eexp %\\\\
      & \mid & \pmb\ilimbs\ \const\ \pmb{[}\ \eexp_{\pmb,}^+\ \pmb{]} \\\\
      & \mid & \pmb{(}\ \eexp\ \pmb{)}
\end{array}
\\]
\\(\ilimbs\ n\ [e_1, \ldots, e_m ]\\) represents \\(e_1 + e_2 2^n + e_3
2^{2n} + \cdots + e_m 2^{(m-1)n}\\).
A *range expression* is evaluated over bit vectors.
\\(\iconst\ w\ n\\) is a bit-vector of width \\(w\\) and value \\(n\\).
\\(\negop\\) (\\(\ineg\\)) is logical negation.
\\(\notop\\) (\\(\inot\\)), \\(\andop\\) (\\(\iand\\)), \\(\orop\\) (\\(\ior\\)), \\(\xorop\\) (\\(\ixor\\)) are respectively bit-wise
negation, bit-wise AND, bit-wise OR, and bit-wise XOR.
\\(\iumod\\) is unsigned remainder.
\\(\isrem\\) is 2's complement signed remainder (sign follows dividend).
\\(\ismod\\) is 2's complement signed remainder (sign follows divisor).
\\(\iuext\\) and \\(\isext\\) are respectively unsigned and signed extension
operations.

\\[
\begin{array}{rclcl}
  \rexp &  ::= & \pmb{(}\ \rexp\ \pmb{)}
  & \mid & \pmb\iconst\ \const\ \const \\\\
        & \mid & \pmb{-}\ \rexp
  & \mid & \rexp\ \pmb\addop\ \rexp \\\\
        & \mid & \rexp\ \pmb\subop\ \rexp
  & \mid & \rexp\ \pmb\mulop\ \rexp \\\\
        & \mid & \pmb\negop\ \rexp
  & \mid & \pmb\ineg\ \rexp \\\\
        & \mid & \pmb\notop\ \rexp
  & \mid & \pmb\inot\ \rexp \\\\
        & \mid & \rexp\ \pmb\andop\ \rexp
  & \mid & \pmb\iand\ \rexp\ \rexp \\\\
        & \mid & \rexp\ \pmb\orop\ \rexp
  & \mid & \pmb\ior\ \rexp\ \rexp \\\\
        & \mid & \rexp\ \pmb\xorop\ \rexp
  & \mid & \pmb\ixor\ \rexp\ \rexp \\\\
        & \mid & \pmb\iumod\ \rexp\ \rexp
  & \mid & \pmb\isrem\ \rexp\ \rexp \\\\
        & \mid & \pmb\ismod\ \rexp\ \rexp
  & \mid & \pmb\ilimbs\ \const\ \pmb[\ \rexp_{\pmb,}^+\ \pmb] \\\\
        & \mid & \pmb\iuext\ \rexp\ \const
  & \mid & \pmb\isext\ \rexp\ \const \\\\
\end{array}
\\]

A *predicate* is represented by an algebraic predicate and a range predicate.
\\[
\begin{array}{rclcl}
\pred &  ::= & \pmb\true
      & \mid & \epred\ \pmb\band\ \rpred
\end{array}
\\]
An *algebraic predicate* is evaluated over the integer domain.
\\(e_1 = e_2\\) (\\(\ieq\ e_1\ e_2\\)) is an equality over algebraic
expressions.
\\(e_1 = e_2\ (\imod\ [m_1, \ldots, m_n])\\) (\\(\ieqmod\ e_1\ e_2\\) \\([m_1,
\ldots, m_n]\\)) is a modular equality.
\\(p_1\ \landop\ p_2\\) (\\(\iand\ p_1\ p_2\\)) is a logical conjunction of
\\(p_1\\) and \\(p_2\\).
The conjunction of a sequence of algebraic predicates \\(e_1, \ldots,
e_n\\) is written as \\(\landop\ [e_1, \ldots, e_n]\\) (\\(\iand\ [e_1, \ldots,
e_n]\\)).
\\[
\begin{array}{rclcl}
  \epred &  ::= & \pmb(\ \epred\ \pmb)
  & \mid & \pmb\true \\\\
         & \mid & \eexp\ \pmb\eqop\ \eexp
  & \mid & \pmb\ieq\ \eexp\ \eexp \\\\
         & \mid & \eexp\ \pmb\eqop\ \eexp\ \pmb(\ \pmb\imod\ [\eexp_{\pmb,}^+]\ \pmb)
  & \mid & \pmb\ieqmod\ \eexp\ \eexp\ [ \eexp_{\pmb,}^+ ] \\\\
         & \mid & \epred\ \pmb\landop\ \epred
  & \mid & \pmb\iand\ \epred\ \epred \\\\
         & \mid & \pmb\landop\ \pmb[\ \epred_{\pmb,}^+\ \pmb]
  & \mid & \pmb\iand\ \pmb[\ \epred_{\pmb,}^+\ \pmb] \\\\
\end{array}
\\]
A *range predicate* specifies the ranges of variables.
\\(\cryptoline\\) offers comparisons such as equality (\\(\eqop\\)), modular
equalities (\\(\iequmod\\), \\(\ieqsmod\\), \\(\ieqsrem\\)), unsigned less than
(\\(\ultop\\)), unsigned less than or equal to (\\(\uleop\\)), unsigned
greater than (\\(\ugtop\\)), unsigned greater than or equal to (\\(\ugeop\\)),
signed less than (\\(\sltop\\)), signed less than or equal to (\\(\sleop\\)),
signed greater than (\\(\sgtop\\)), and signed greater than or equal to
(\\(\sgeop\\)).
\\[
\begin{array}{rclcl}
  \rpred &  ::= & \pmb{(}\ \rpred\ \pmb{)}
  & \mid & \pmb\true \\\\
         & \mid & \rexp\ \pmb\eqop\ \rexp
  & \mid & \pmb\ieq\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\eqop\ \rexp\ \pmb(\ \iumod\ \rexp\ \pmb)
  & \mid & \pmb\iequmod\ \rexp\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\eqop\ \rexp\ \pmb(\ \ismod\ \rexp\ \pmb)
  & \mid & \pmb\ieqsmod\ \rexp\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\eqop\ \rexp\ \pmb(\ \isrem\ \rexp\ \pmb)
  & \mid & \pmb\ieqsrem\ \rexp\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\ultop\ \rexp
  & \mid & \pmb\iult\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\uleop\ \rexp
  & \mid & \pmb\iule\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\ugtop\ \rexp
  & \mid & \pmb\iugt\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\ugeop\ \rexp
  & \mid & \pmb\iuge\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\sltop\ \rexp
  & \mid & \pmb\islt\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\sleop\ \rexp
  & \mid & \pmb\isle\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\sgtop\ \rexp
  & \mid & \pmb\isgt\ \rexp\ \rexp \\\\
         & \mid & \rexp\ \pmb\sgeop\ \rexp
  & \mid & \pmb\isge\ \rexp\ \rexp \\\\
         & \mid & \pmb\negop \rpred
  & \mid & \pmb\ineg \rpred \\\\
         & \mid & \rpred\ \pmb{\landop}\ \rpred
  & \mid & \pmb{\iand}\ \rpred\ \rpred \\\\
         & \mid & \rpred\ \pmb{\lorop}\ \rpred
  & \mid & \pmb{\ior}\ \rpred\ \rpred \\\\
         & \mid & \pmb{\landop}\ \pmb{[}\ \rpred_{\pmb,}^+\ \pmb{]}
  & \mid & \pmb{\iand}\ \pmb{[}\ \rpred_{\pmb,}^+\ \pmb{]} \\\\
         & \mid & \pmb{\lorop}\ \pmb{[}\ \rpred_{\pmb,}^+\ \pmb{]}
  & \mid & \pmb{\ior}\ \pmb{[}\ \rpred_{\pmb,}^+\ \pmb{]}
\end{array}
\\]

There are numerous *instructions* supported by \\(\cryptoline\\).
\\(\imov\ x\ a\\) assigns destination variable \\(x\\) by the value of the
source atom \\(a\\).
\\(\icmov\ x\ c\ a_1\ a_2\\) assigns destination variable \\(x\\) by the value of the
source atom \\(a_1\\) if the condition bit \\(c\\) is \\(1\\), and otherwise by
the value of the source atom \\(a_2\\).
\\(\iadd\ x\ a_1\ a_2\\) assigns \\(x\\) by the addition of the source atoms
\\(a_1\\) and \\(a_2\\).
Note that \\(\iadd\\) may overflow.
\\(\iadds\ c\ x\ a_1\ a_2\\) assigns \\(x\\) by the addition of the source atoms
\\(a_1\\) and \\(a_2\\) with carry bit \\(c\\) set.
\\(\iadc\ x\ a_1\ a_2\ y\\) assigns \\(x\\) by the addition of the carry bit \\(y\\)
and the source atoms \\(a_1\\) and \\(a_2\\).
\\(\iadcs\\) is the same as \\(\iadc\\) except the carry bit is set.
There are also instructions \\(\isub\\) for subtraction; \\(\isubc\\), \\(\isbc\\)
and \\(\isbcs\\) for subtraction with carry; \\(\isubb\\), \\(\isbb\\), and
\\(\isbbs\\) for subtraction with borrow.
\\(\imul\\) and \\(\imuls\\) are half multiplication operations.
The differenace is that \\(\imuls\\) sets the carry bit if the
multiplication under- or over-flow.
\\(\imull\\) is full multiplication with results split into high part and
low part.
\\(\imulj\\) is also full multiplication without splitting the results.
\\(\inondet\\) assigns a variable by a nondeterministic value.
\\(\iset\ x\\) assigns the bit variable \\(x\\) by \\(1\\) while \\(\iclear\ x\\)
assigns the bit variable \\(x\\) by \\(0\\).
\\(\ishl x a n\\) shifts the source atom \\(a\\) left by \\(n\\) and stores the
results in \\(x\\).
The number of shifts \\(n\\) is an atom and need not be a constant.
A non-constant \\(n\\) is still checked for safety and carried by the
range specification, but the algebraic abstraction drops the
instruction and warns that it has done so, leaving \\(x\\) unrelated to
\\(a\\); the same holds of \\(\ishr\\) and \\(\isar\\).
\\(\ishls o x a n\\) is the same as \\(\ishls x a n\\) except that the bits
shifted out are stored in \\(o\\).
\\(\ishr x a n\\) shifts the source atom \\(a\\) right logically by \\(n\\) and
stores the results in \\(x\\).
\\(\ishrs x o a n\\) is the same as \\(\ishr x a n\\) except that the bits
shifted out are stored in \\(o\\).
\\(\isar\\) and \\(\isars\\) are the same as \\(\ishr\\) and \\(\ishrs\\) respectively
except that the right shift is arithmetic.
\\(\icshl x_h x_l a_1 a_2 n\\) concatenates the source atoms \\(a_1\\) (high
bits) and \\(a_2\\) (low bits), shifts the concatenation left by \\(n\\),
stores the high bits of the shifted concatenation in \\(x_h\\), and stores
the low bits shifted right by \\(n\\) in \\(x_l\\).
\\(\icshr x_h x_l a_1 a_2 n\\) concatenates the source atoms \\(a_1\\) (high
bits) and \\(a_2\\) (low bits), shifts the concatenation right logically
by \\(n\\), stores the high bits of the shifted concatenation in \\(x_h\\),
and stores the low bits in \\(x_l\\).
\\(\icshr x_h x_l o a_1 a_2 n\\) is the same as \\(\icshr x_h x_l a_1 a_2 n\\)
except that the bits shifted out are stored in \\(o\\).
\\(\ispl x_h x_l a n\\) splits the source atom \\(a\\) at position \\(n\\), stores
the high bits in \\(x_h\\), and stores the low bits in \\(x_l\\).
\\(\isplit\\) is the same as \\(\ispl\\) except that the high bits and the low
bits are extended to the size of \\(a\\).
While the low bits are always zero extended, the high bits are sign
extended if \\(a\\) is signed and otherwise zero extended.
\\(\ijoin x a_1 a_2\\) assigns \\(x\\) by the concatenation of the source
atoms \\(a_1\\) (high bits) and \\(a_2\\) (low bits).
\\(\iand\\), \\(\ior\\), \\(\inot\\), and \\(\ixor\\) are bit-wise operations.
\\(\icast t x a\\) assigns \\(x\\) by the source atom \\(a\\) casted to the type
\\(t\\).
\\(\ivpc t x a\\) is the same as \\(\icast t x a\\) except that the integer
interpretation of \\(x\\) must be the same as the integer interpretation
of \\(a\\).
\\(\iassert\\) tells \\(\cryptoline\\) to verify the specified predicate.
\\(\iassume\\) tells \\(\cryptoline\\) to assume the specified predicate.
\\(\icut\ e\ \band\ r\\) is an alias of one \\(\iecut\ e\\) followed by a
\\(\ircut\ r\\).
For \\(\iecut\\), \\(\cryptoline\\) verifies the specified algebraic predicate
and starts afresh with the predicate assumed when verifying algebraic
properties.
Similarly for \\(\ircut\\), \\(\cryptoline\\) verifies the specified range
predicate and starts afresh with the predicate assumed when verifying
range properties.
\\(\ighost\\) can introduce logical variables that must only be used in
specifications such as \\(\iassert\\), \\(\iassume\\), \\(\icut\\), \\(\iecut\\),
\\(\ircut\\), and postconditions.
The predicate in a \\(\ighost\\) instruction is always assumed.
\\(\icall\ p\ (a_1, a_2, \ldots, a_n)\\) executes a defined procedure \\(p\\)
with arguments \\(a_1, a_2, \ldots, a_n\\).

\\[
\begin{array}{rclcl}
  \instr &  ::= & \pmb\imov\ \lval\ \atom
         & \mid & \pmb\icmov\ \lval\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\iadd\ \lval\ \atom\ \atom
         & \mid & \pmb\iadds\ \lval\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\iadc\ \lval\ \atom\ \atom\ \var
         & \mid & \pmb\iadcs\ \lval\ \lval\ \atom\ \atom\ \var \\\\
         & \mid & \pmb\isub\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\isubc\ \lval\ \lval\ \atom\ \atom
         & \mid & \pmb\isubb\ \lval\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\isbc\ \lval\ \atom\ \atom\ \var
         & \mid & \pmb\isbcs\ \lval\ \lval\ \atom\ \atom\ \var \\\\
         & \mid & \pmb\isbb\ \lval\ \atom\ \atom\ \var
         & \mid & \pmb\isbbs\ \lval\ \lval\ \atom\ \atom\ \var \\\\
         & \mid & \pmb\imul\ \lval\ \atom\ \atom
         & \mid & \pmb\imuls\ \lval\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\imull\ \lval\ \lval\ \atom\ \atom
         & \mid & \pmb\imulj\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\inondet\ \lval \\\\
         & \mid & \pmb\iset\ \lval
         & \mid & \pmb\iclear\ \lval \\\\
         & \mid & \pmb\ishl\ \lval\ \atom\ \atom
         & \mid & \pmb\ishls\ \lval\ \lval\ \atom\ \const \\\\
         & \mid & \pmb\ishr\ \lval\ \atom\ \atom
         & \mid & \pmb\ishrs\ \lval\ \lval\ \atom\ \const \\\\
         & \mid & \pmb\isar\ \lval\ \atom\ \atom
         & \mid & \pmb\isars\ \lval\ \lval\ \atom\ \const \\\\
         & \mid & \pmb\icshl\ \lval\ \lval\ \atom\ \atom\ \const \\\\
         & \mid & \pmb\icshr\ \lval\ \lval\ \atom\ \atom\ \const
         & \mid & \pmb\icshrs\ \lval\ \lval\ \lval\ \atom\ \atom\ \const \\\\
         & \mid & \pmb\ispl\ \lval\ \lval\ \atom\ \const
         & \mid & \pmb\isplit\ \lval\ \lval\ \atom\ \const \\\\
         & \mid & \pmb\ijoin\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\iand\ \lval\ \atom\ \atom
         & \mid & \pmb\ior\ \lval\ \atom\ \atom \\\\
         & \mid & \pmb\ixor\ \lval\ \atom \atom
         & \mid & \pmb\inot\ \lval\ \atom \\\\
         & \mid & \pmb\icast\ \typ\ \lval\ \atom
         & \mid & \pmb\ivpc\ \typ\ \lval\ \atom \\\\
         & \mid & \pmb\iassert\ \pred
         & \mid & \pmb\iassume\ \pred \\\\
         & \mid & \pmb\icut\ \predclause
         & \mid & \pmb\iecut\ \epredclause \\\\
         & \mid & \pmb\ircut\ \rpredclause
         & \mid & \pmb\ighost\ \tvar_{\pmb,}^+\ \pmb{:}\ \pred \\\\
         & \mid & \pmb\icall\ \id\ \pmb{(}\ \atom_{\pmb,}^* \pmb{)}
  & \mid & \pmb\inop
\end{array}
\\]

Instructions \\(\iadd\\), \\(\iadds\\), \\(\iadc\\), \\(\iadcs\\), \\(\isub\\), \\(\isubc\\),
\\(\isubb\\), \\(\isbc\\), \\(\isbcs\\), \\(\isbb\\), \\(\isbbs\\), \\(\imul\\), \\(\imuls\\),
\\(\imull\\), \\(\imulj\\), \\(\isplit\\), and \\(\ispl\\) also have specific unsigned
and signed versions with prefix "u" or "s".
For example, \\(\iuadd\\) and \\(\isadd\\) are respectively unsigned and
signed versions of \\(\iadd\\).

### Vectors

\\(\cryptoline\\) also supports *vectors*, that is, fixed-length sequences
of values of a common type.
Vectors are meant for modeling SIMD instructions, where one machine
instruction operates on several lanes of a wide register at once.
A vector is not a new kind of value.
A vector variable of type \\(t[n]\\) is expanded into \\(n\\) scalar variables
of type \\(t\\), and a vector instruction is expanded into \\(n\\) scalar
instructions, one per element.
Everything in this section is therefore an abbreviation for the scalar
language described above; no vector ever reaches an SMT solver or a
computer algebra system as a vector.

A *vector type* is a type followed by its length in brackets.
The length must be a positive numeral.
\\[
\vectyp ::= \typ\ \pmb{[}\ \mN\ \pmb{]}
\\]
The element type is an ordinary type, so its width is unrestricted:
\\(\uint{64}[4]\\) (four unsigned 64-bit elements, for instance a 256-bit
AVX2 register viewed as four 64-bit lanes), \\(\sint{16}[16]\\), and
\\(\uint{128}[2]\\) are all vector types.

Vector variables are distinguished from scalar variables lexically:
the name of a vector variable always starts with \\(\pcnt\\) and the name
of a scalar variable never does.
Like a scalar variable, a vector variable may be given its type
explicitly in either order.
\\[
  \begin{array}{rcl}
    \vecvar & ::= & \pcnt \id \\\\
    \tvecvar & ::= & \vecvar @ \vectyp \mid \vectyp\ \vecvar
  \end{array}
\\]
The \\(i\\)-th element of a vector \\(v\\) is written \\(v \pmb{[} i \pmb{]}\\),
with \\(i\\) counted from \\(0\\).
An element is an ordinary scalar atom and may be used wherever a
scalar atom, an algebraic expression, or a range expression is
expected.

A *vector atom* denotes a sequence of scalar atoms of a common type.
\\[
  \begin{array}{rcl}
    \vecatom & ::= & \vecvar \mid \tvecvar \\\\
             & \mid & \pmb{[}\ \atom_{\pmb,}^+\ \pmb{]} \\\\
             & \mid & \const @ \vectyp \\\\
             & \mid & \vecatom\ \pmb{[}\ \sel_{\pmb,}^+\ \pmb{]} \\\\
             & \mid & \vecatom\ \pmb\catop\ \vecatom \\\\
             & \mid & \vecatom\ \pmb\catop\ \const \\\\
             & \mid & \pmb(\ \vecatom\ \pmb)
  \end{array}
\\]
A *vector literal* \\([a_1, \ldots, a_n]\\) builds a vector out of scalar
atoms; all of \\(a_1, \ldots, a_n\\) must have the same type.
A *constant vector* \\(c @ t[n]\\) *splits* the constant \\(c\\) into \\(n\\)
elements of type \\(t\\), least significant element first; it does not
replicate \\(c\\).
\\(v_1\ \catop\ v_2\\) concatenates two vectors, the elements of \\(v_1\\)
coming first; both must have the same element type.
\\(v\ \catop\ c\\) duplicates \\(v\\) \\(c\\) times.
Only a vector variable and a vector literal may be assigned to.
A selection, a concatenation, a duplication, and a constant vector are
read-only and are rejected as destinations.

A *selection* picks elements out of a vector, either by listing
indices or by slicing.
\\[
  \begin{array}{rcl}
    \sel & ::= & \const\ \pmb{:}\ \const \mid \const\ \pmb{:} \mid
                 \pmb{:}\ \const \\\\
         & \mid & \const\ \pmb{:}\ \const\ \pmb{:}\ \const \mid
                  \const\ \pmb{:}\ \pmb{:}\ \const \mid
                  \pmb{:}\ \const\ \pmb{:}\ \const
  \end{array}
\\]
A slice \\(i \pmb: j \pmb: k\\) selects the elements at indices \\(i\\),
\\(i + k\\), \\(i + 2k\\), \\(\ldots\\) up to but excluding \\(j\\).
An omitted \\(i\\) defaults to \\(0\\), an omitted \\(j\\) defaults to the length
of the vector, and an omitted \\(k\\) defaults to \\(1\\).
A step of \\(0\\) is an error, and a slice whose step runs away from its
bound is empty.
A negative index \\(i\\) denotes the index \\(\mathit{len} + i + 1\\), so
\\(v[0\pmb{:}\text{-}1]\\) is the whole of \\(v\\).
Instead of slices, a selection may be a list of at least two indices,
as in \\(v[3, 2, 1, 0]\\), which is how shuffles are expressed.
A single index in brackets is an element rather than a selection:
\\(v[0]\\) is a scalar atom, and the one-element vector containing it must
be written as a slice such as \\(v[0\pmb{:}1]\\).

An instruction is a vector instruction whenever its destination is a
vector.
The following instructions have vector forms: \\(\imov\\), \\(\icmov\\),
\\(\iadd\\), \\(\iadds\\), \\(\isub\\), \\(\isubc\\), \\(\isubb\\), \\(\imul\\), \\(\imull\\),
\\(\imulj\\), \\(\isplit\\), \\(\ispl\\), \\(\ishl\\), \\(\ishls\\), \\(\ishr\\), \\(\ishrs\\),
\\(\isar\\), \\(\isars\\), \\(\irol\\), \\(\iror\\), \\(\iset\\), \\(\iclear\\), \\(\inondet\\),
\\(\iseteq\\), \\(\isetne\\), \\(\iand\\), \\(\ior\\), \\(\ixor\\), \\(\inot\\), \\(\ijoin\\),
\\(\icast\\), \\(\ivpc\\), together with the unsigned and signed versions of
those that have them.
The instructions that thread a carry or borrow through their operands,
namely \\(\iadc\\), \\(\iadcs\\), \\(\isbc\\), \\(\isbcs\\), \\(\isbb\\), \\(\isbbs\\),
\\(\icshl\\), \\(\icshr\\), and \\(\icshrs\\), have no vector form.
The two source vectors of a binary vector instruction must have the
same length and the same element type, and the destination must have
the same length as the sources.

Two instructions exist only in vector form.
\\(\ibroadcast\ v\ n\ a\\) assigns \\(v\\) by \\(n\\) copies of the vector atom
\\(a\\), so the result has \\(n\\) times as many elements as \\(a\\).
\\(\iextract\ v\ [n_1, \ldots, n_k]\ a_1\ \cdots\ a_k\\) assigns \\(v\\) by the
\\(n_i\\)-th element of \\(a_i\\) for each \\(i\\); the sources must all have the
same element type, and there must be as many indices as sources.
\\[
  \begin{array}{rcl}
    \vecinstr & ::= & \pmb\ibroadcast\ \veclval\ \const\ \vecatom \\\\
              & \mid & \pmb\iextract\ \veclval\ \pmb{[}\ \mN_{\pmb,}^+
                       \ \pmb{]}\ \vecatom^+
  \end{array}
\\]

For example, the following program loads four 64-bit words into a
vector, builds a second vector holding four copies of a shift amount,
shifts the first vector element-wise, and finally assembles a third
vector from the low half of one and the high half of the other.

```
mov %v@uint64[4] [x0, x1, x2, x3];
broadcast %s@uint64[4] 4 [24@uint64];
shl %w %v %s;
mov %u@uint64[4] (%v[0, 1] ++ %w[2, 3]);
```

Vectors may also appear in predicates.
An equality or a comparison between two vectors holds element-wise, in
both the algebraic and the range parts, and the modular suffixes of an
equality accept vectors as their moduli.
In a range expression, \\(\ijoin\ v\\) concatenates all elements of \\(v\\),
from low to high, into a single bit-vector, and \\(\mathit{concat}\\)
concatenates two vectors element-wise.
In a list of algebraic expressions, \\(\mulop v\\) splices the elements of
\\(v\\) into the list, so a limb expression over a whole vector may be
written as \\(\ilimbs\ 64\ [\mulop v]\\).
Ghost variables and the formal parameters of a procedure may be
vectors, declared with a vector type in the same way as vector
variables elsewhere.

Sometimes a predicate has to be proved with facts that have been cut off.
\\(\cryptoline\\) offers the specification of hints required to prove a predicate.

\\[
\begin{array}{rclcl}
  \predclause &  ::= & \true %\\\\
              & \mid & \epredclause\ \pmb{\\&\\&}\ \rpredclause \\\\
  \epredclause &  ::= & \epred %\\\\
              & \mid & \epred\ \pmb\iprove\ \pmb\iwith\ \pmb[
                       \provewith_{\pmb,}^+ \pmb] \\\\
              & \mid & \epredclause_{\pmb,}^+ \\\\
  \rpredclause &  ::= & \rpred %\\\\
              & \mid & \rpred\ \pmb\iprove\ \pmb\iwith\ \pmb[
                       \provewith_{\pmb,}^+ \pmb]\\\\
              & \mid & \rpredclause_{\pmb,}^+ \\\\
  \cas &  ::= & \pmb\singularsolver
              & \mid & \pmb\sagesolver \\\\
              & \mid & \pmb\magmasolver
              & \mid & \pmb\mathematicasolver \\\\
              & \mid & \pmb\macaulaysolver
              & \mid & \pmb\maplesolver \\\\
  \provewith &  ::= & \pmb\precondition
             & \mid & \pmb\all\ \pmb\cuts \\\\
             & \mid & \pmb\all\ \pmb\assumes
             & \mid & \pmb\all\ \pmb\ghosts \\\\
             & \mid & \pmb\cuts\ \pmb[ \mN_{\pmb,}^+ \pmb]
             & \mid & \pmb\algebra\ \pmb\solver\ \cas \\\\
             & \mid & \pmb\algebra\ \pmb\solver\ \pmb\smt\pmb:\path
             & \mid & \pmb\range\ \pmb\solver\ \path
\end{array}
\\]

Note that the indices of \\(\iecut\\) and \\(\ircut\\) are numbered separately
(starting from 0).
When verifying algebraic properties, \\(\ircut\\) instructions are
ignored.
When verifying range properties, \\(\iecut\\) instructions are
ignored.
For example, consider the following program.

```
mov x 15@uint16;
ecut x = 15;
mov y 3@uint16;
cut y = 3 && and [x = 15@16, y = 3@16];
add z x y;
rcut z = 18@16;
```

If we want to prove \\(e\ \provewith\ [\cuts [1]]\ \band\ r\ \provewith
[\cuts [1]]\\), then \\(y = 3\\) will be assumed when proving the algebraic
property \\(e\\) while \\(z = 18@16\\) will be assumed when proving the range
property \\(r\\).

A *procedure* is a parameterized program together with its
specification (precondition and postcondition).

\\[
\proc ::= \pmb\proc\ \id\ \pmb{(}\ \formals\ \pmb{)} = \pmb\\{\ \pre\ \pmb\\}\ \prog\ \pmb\\{\ \post\ \pmb\\}
\\]

The *formal parameters* of a procedure may be separated by a
semicolon into *inout} and \emph{out* variables.

\\[
\formals ::= \tvar_{\pmb,}^* \mid \tvar_{\pmb,}^*
\ \pmb{;}\ \tvar_{\pmb,}^*
\\]

Variables before the semicolon are inout variables while variables
after the semicolon are out variables.
Formal parameters without a semicolon are all inout variables.
The difference between inout and out variables is that when calling a
procedure, actual parameters of the inout formal variables must be
defined but this is not required for the actual parameters of the out
formal variables.
However, this does not mean that an out variable can be read before
initialized.
Every variable must be initialized before reading its value.
A *precondition* is a predicate.
\\[
\pre ::= \pred
\\]
A *postcondition* is a predicate clause.
\\[
\post ::= \predclause
\\]

A *statement* is a declaration of a procedure or a named integer.
\\[
\begin{array}{rclcl}
\stmt &  ::= & \proc %\\\\
      & \mid & \pmb\iconst\ \id\ \pmb\eqop\ \const
\end{array}
\\]

A *program* is a sequence of semicolon separated statements.
The entry point of the program is the *main* procedure.
Other procedures called in main are inlined.
\\[
\prog ::= \stmt_{\pmb;}^+
\\]
