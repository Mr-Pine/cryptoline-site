---
title: "Reference"
weight: 3
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

## Instructions

### mov
`mov x a` assigns destination variable `x` by the value of the
source atom `a`.


### cmov
`cmov x c a1 a2` assigns destination variable `x` by the value of the
source atom `a1` if the condition bit `c` is `1`, and otherwise by
the value of the source atom `a2`.


### add
`add x a1 a2` assigns `x` by the addition of the source atoms
`a1` and `a2`.

Note that `add` may overflow.


### adds
`adds c x a1 a2` assigns `x` by the addition of the source atoms
`a1` and `a2` with carry bit `c` set.


### adc
`adc x a1 a2 y` assigns `x` by the addition of the carry bit `y`
and the source atoms `a1` and `a2`.


### adcs
`adcs c x a1 a2 y` is the same as `adc` except the carry bit is set.


### sub
`sub x a1 a2` is subtraction.


### subc
`subc c x a1 a2` is subtraction with carry.


### subb
`subb c x a1 a2` is subtraction with borrow.


### sbc
`sbc x a1 a2 y` is subtraction with carry.


### sbcs
`sbcs c x a1 a2 y` is subtraction with carry.


### sbb
`sbb x a1 a2 y` is subtraction with borrow.


### sbbs
`sbbs c x a1 a2 y` is subtraction with borrow.


### mul
`muls x a1 a2` is half multiplication operations.


### muls
`muls xh xl a1 a2` is half multiplication operations.

`muls` sets the carry bit if the
multiplication under- or over-flow.


### mull
`mull xh xl a1 a2` is full multiplication with results split into high part and
low part.


### mulj
`mulj x a1 a2` is also full multiplication without splitting the results.


### nondet
`nondet x` assigns a variable by a nondeterministic value.


### set
`set x` assigns the bit variable `x` by `1`.


### clear
`clear x` assigns the bit variable `x` by `0`.


### shl
`shl x a n` shifts the source atom `a` left by `n` and stores the
results in `x`.

A constant `n` ranges from `0`, which copies `a` unchanged, up to but
excluding the width of `a`. The same holds of `shr` and `sar`.


### shls
`shls o x a n` is the same as `shls x a n` except that the bits
shifted out are stored in `o`.

Here `n` must be positive, since `o` holds the `n` bits shifted out and
no variable is zero bits wide. The same holds of `shrs` and `sars`.


### shr
`shr x a n` shifts the source atom `a` right logically by `n` and
stores the results in `x`.


### shrs
`shrs x o a n` is the same as `shr x a n` except that the bits
shifted out are stored in `o`.


### sar
`sar x a n` are the same as `shr`
except that the right shift is arithmetic.


### sars
`sars x a n` are the same as `shrs`
except that the right shift is arithmetic.


### cshl
`cshl xh xl a1 a2 n` concatenates the source atoms `a1` (high
bits) and `a2` (low bits), shifts the concatenation left by `n`,
stores the high bits of the shifted concatenation in `xh`, and stores
the low bits shifted right by `n` in `xl`.


### cshr
`cshr xh xl a1 a2 n` concatenates the source atoms `a1` (high
bits) and `a2` (low bits), shifts the concatenation right logically
by `n`, stores the high bits of the shifted concatenation in `xh`,
and stores the low bits in `xl`.


### cshrs
`cshr xh xl o a1 a2 n` is the same as `cshr xh xl a1 a2 n`
except that the bits shifted out are stored in `o`.


### spl
`spl xh xl a n` splits the source atom `a` at position `n`, stores
the high bits in `xh`, and stores the low bits in `xl`.

Here `n` must lie strictly between `0` and the width of `a`, since
either end would leave one destination zero bits wide.


### split
`split xh xl a n` is the same as `spl` except that the high bits `xh` and the low
bits `xl` are extended to the size of `a`.

While the low bits are always zero extended, the high bits are sign
extended if `a` is signed and otherwise zero extended.

Since both destinations are as wide as `a`, `n` may be `0`, which puts
all of `a` in `xh` and leaves `xl` zero, or the width of `a`, which puts
all of `a` in `xl` and leaves `xh` zero. The latter needs an unsigned
`xh`: for a signed `a` it would hold the sign of `a` repeated, which no
single instruction produces.


### join
`join x a1 a2` assigns `x` by the concatenation of the source
atoms `a1` (high bits) and `a2` (low bits).


### and
`and x a1 a2` is bit-wise and operation.


### or
`or x a1 a2` is bit-wise or operation.


### xor
`xor x a1 a2` is bit-wise xor operation.


### not
`not x a` is bit-wise not operation.


### cast
`cast t x a` assigns `x` by the source atom `a` casted to the type
`t`.


### vpc
`vpc t x a` is the same as `cast t x a` except that the integer
interpretation of `x` must be the same as the integer interpretation
of `a`.


### assert
`assert pred` tells CryptoLine to verify the specified predicate `pred`.


### assume
`assume pred` tells CryptoLine to assume the specified predicate `pred`.


### cut
`cut e && r` is an alias of one `ecut e` followed by a
`rcut r`.


### ecut
For `ecut epred`, CryptoLine verifies the specified algebraic predicate
`epred`
and starts afresh with the predicate assumed when verifying algebraic
properties.


### rcut
Similarly for `rcut rpred`, CryptoLine verifies the specified range
`rpred`
predicate and starts afresh with the predicate assumed when verifying
range properties.


### ghost
`ghost a1, a2, ..., an : P && Q` can introduce logical variables
`a1, a2, ..., an` that must only be used in
specifications such as `assert`, `assume`, `cut`, `ecut`,
`rcut`, and postconditions.

The predicate `P && Q` in a `ghost` instruction is always assumed.


### call
`call p (a1, a2, ..., an)` executes a defined procedure `p`
with arguments `a1, a2, ..., an`.


### case
`case n = a [k1, ..., km] { body }` runs `body` once for every listed
value of the atom `a`, with `n` bound to that value as a constant, and
keeps the run that matches the value `a` actually has.

Ranges abbreviate a run of values, so `[0 .. 3]` is `[0, 1, 2, 3]` and
`[1, 3, 10 .. 12]` is `[1, 3, 10, 11, 12]`. The values must be distinct.
The body refers to the bound value as `$n`, like any other named
constant, which makes it usable wherever an instruction requires a
constant rather than an atom, such as the position of a `split` or the
index of a vector element.

Without an `else`, a `case` asserts that `a` is one of the listed
values, and verification fails if `a` can be anything else.

`case n = a [k1, ..., km] { body } else { other }` runs `other` when `a`
is none of the listed values, and asserts nothing about `a`. The two
forms differ in what an algebraic proof can conclude: without an `else`
one of the listed values was taken, so `a` is known to be that value,
whereas with one the algebra cannot tell which branch ran, because
whether the subject fell in the list is a range property. Use the plain
form when the list really does cover every reachable value.

Only what every branch assigns, the `else` branch included, is an output
of the statement. A variable one branch leaves alone keeps whatever it
held before.


### repeat
`repeat n = [k1, ..., km] { body }` runs `body` once for each listed
value, in order, with `n` bound to that value as a constant.

Unlike a `case`, the values are not something the program chooses
between, so the copies are ordinary straight-line code: nothing is
merged afterwards, and a later copy sees what an earlier one assigned.
It takes the same value lists and the same `$n` as a `case`, and is
meant for repeating an operation across the lanes of a vector.

```
repeat i = [0 .. 3] {
  mov %dst[$i], %src[$i]
};
```
