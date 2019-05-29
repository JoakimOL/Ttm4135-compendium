
# Number theory

This part is mostly just stolen from the slides. Not much of interest here except for modular
inverses, groups and fields.

## Basic number theory
$\mathbb{Z}$ denotes the set of integers\
_a_ divides _b_ if there exists a _k_ in $\mathbb{Z}$ such that $a*k = b$ \
$a*k = 3*2 = 6 = b$\
An integer is prime if the only positive divisors are 1 and _p_\
checking primality for a number _n_ can be done by trial division up to $sqrt(n)$.

### Basic properties of factors

 1. if _a_ divides _b_ and _a_ divides _c_ then _a_ divides _b_+_c_
 2. if _p_ is a prime and _p_ divides _ab_, then _p_ divides _a_ or _b_

Example:\
$6|18$ and $6|24$ $\rightarrow$ $6|42$

### Division algorithm

> for a and b in Z, a > b, there exists q and r in Z such that
> $a  = bq + r$
> where $0 \leq  r < b$.

## GCD
The value d is the GCD of a and b if all hold:
1. D divides a and b
2. if c divides a and b then c divides d (the greatest)
3. d > 0, by definition of integers

> a and b are relatively prime if $gcd(a,b) = 1$

### Euclidean algorithm & extended euclidean algorithm(EEA)
Euclidean algorithm is for finding gcd.
See slides 2 for pseudo-code if you need it
EEA finds integers x and y in $a*x + b*y = d$, we're interested in the case where a and b are
co-prime (x and y = 1)

## Modular arithmetic
> b is the residue of a modulo n if a - b = kn for some integer k.

\
$a \equiv b(\mod n) \leftrightarrow a - b = kn$

Given $a \equiv b (\mod n)$ and $c \equiv d (\mod n)$ then\

1. $a + c \equiv b + d (\mod n)$\
2. $ac \equiv bd (\mod n)$
3. $ka \equiv kb (\mod n)$

Note:\
This means we can always reduce the inputs modulo _n_ before performing additions or
multiplications

### Residue class

>  Definition:
The set ${r_0,  r_1, ... r_{n-1}}$ is called a complete set of residues modulo n if, for every
integer a, $a\equiv r_i (\mod n)$ for exactly one $r_i$

We usually denote this set as the complete set of residues and denote it $\mathbb{Z}$


### Notation: a mod n
we write a mod n to denote the value  a' in the complete set of residues with
$a\prime \equiv a (\mod n)$
$a = k*n + a\prime$
$0 \leq a\prime < a$

## Groups
> a group is a set, _G_, with a binary operation $\cdot$ satisfying the following properties:

1. Closure:  $a\cdot b \in G$,   $\forall a,b \in G$
2. identity: there exists an element 1, so that $a\cdot 1 = 1 \cdot a = a, \forall a \in G$
3. inverse: for all _a_, there exists an element _b_ so that $a \cdot b = 1, \forall a \in G$
4. associative: $(a\cdot b) \cdot c = a \cdot(b \cdot c), \forall a,b,c \in G$ (Doesn't matter where
   you put the parentheses)

In this course we will only consider commutative groups, which are also commutative:

5. $\forall a,b \in G,  a \cdot b = b\cdot a$ (order of operands doesn't matter)

### Cyclic groups
 - The order of a group, G, often written |G|, is the number of elements in G
 - we write $g^k$  to denote repeated application of g using the group operation.
    - the order of an element g, written |g|, is the smallest integer k with $g^k = 1$
- a group element g is a generator for G if $|g| = |G|$
- a group is cyclic if it has a generator


## Computing inverses modulo n

> the inverse of _a_ , if it exists,, is a value x such that
$ax \equiv 1 (\mod n)$
and is written $a^{-1} mod n$

In cryptosystems, we often need to find inverses so we can decrypt, or undo, certain operations

> Theorem:
> Let $0 < a < n$. Then _a_ has an inverse modulo n iff $gcd(a,n) = 1$. (a and n are co-prime)

## Modular inverses using Euclidean algorithm
to find the inverse of _a_ we can use the Euclidean algorithm, which is very efficient.
Since gcd(a,n) = 1, we can find ax + ny   = 1 for integers x and y by Euclidean algorithm.

### An actual example of modular inverses.
Since there are really bad resources for this:\
From exam 2018\
$8^{-1}\mod 21$\
Set up the equation:

$21 = 8( factor ) + remainder$ \
$21 = 8(2) + 5$\
shift numbers one to the left\
$8 = 5(factor) + remainder$\
$8 = 5(1) + 3$\
keep shifting till the remainder is 1\
$5 = 3(1) + 2$\
$3 = 2(1) + 1$\

Now, for each line exchange the equation so that the remainder is alone on its side\
Labelling each equation in parentheses.\

$21 + 8(-2) = 5$ (eq 4)\
$8  + 5(-1) = 3$ (eq 3)\
$5  + 3(-1) = 2$ (eq 2)\
$3  + 2(-1) = 1$ (eq 1)\

Look at equation (1). You see it uses the number 2, which is defined in equation (2). Substitute
equation (2) in (1):\

$3+(5+3(-1))(-1) = 1 \mod 21$\
$3+(5(-1)+3) = 1 \mod 21$\
$3(2)+5(-1) = 1 \mod 21$\

Now we see the number 3, which can be substituted using equation (3):\

$(8 + 5(-1))(2)+5(-1) = 1 \mod 21$\
$8(2) + 5(-3) = 1 \mod 21$\

Do the same for the number 5, using equation (4):\
$8(2) + (21 + 8(-2))(-3) = 1 \mod 21$\
$8(2) + 21(-3) + 8(6) = 1 \mod 21$\
$8(8) + 21(-3) = 1 \mod 21$\

-3 is not representable in mod 21, but its absolute value is smaller than our modulus of 21. Substitute -3 with 21-3 = 18.\


$8(8) + 21(18) = 1 \mod 21$\

We have 21(18), which is 18 times the modulus. Anything multiplied with the modulus is 0:\

$8(8) = 1 \mod 21$\

This is our solution. Modular inverses should satisfy $XX^{-1}  = 1\mod n$, and we see that $8*8 = 1
\mod 21$.

### Another example
This example is implicitly required in an RSA exercise from the 2018 exam. We're required to
calculate _e_, given _n_ and _d_. The formula for _e_ is $e = d^{-1} \mod (\phi(n))$. For completeness, $\phi(n) = \phi(21)$ prime factors of 21 are 3 and 7.\
$\phi(21) = (3-1)(7-1) = 12$\

Following the same steps as the above example:\
$e = 5^{-1} \mod (12)$\
$12 = 5(factor) + remainder$\
$12 = 5(2) + 2$\
$5 = 2(2) + 1$\

$5+2(-2) = 1$ (1)\
$12+5(-2) = 2$ (2)\

Substituting (2) in (1)

$5 + (12 + 5(-2))(-2) = 1 \mod 12$\
$5 + 12(-2) + 5(4) = 1 \mod 12$\
$5(5) + 12(-2) = 1 \mod 12$\
$5(5) + 12(10) = 1 \mod 12$ again, -2 doesn't exist in mod 12. 12-2 = 10 works since 2 is smaller than
10.
$5(5) = 1 \mod 12$\

The answer is 5. We see that $5(5) \mod12$ does indeed equal 1.

## the set of residues $\mathbb{Z}_p^*$
a complete set of resides modulo any prime _p_ with the 0 removed forms a group under multiplication
denoted $\mathbb{Z}_p^*$. It has some interesting properties:

- The order of $\mathbb{Z}_p^*$ is $p-1$
- it is also cyclic.
- it has many generators

## Finding a generator for $\mathbb{Z}_p^*$
A generator of $\mathbb{Z}_p^*$ is an element of order $p-1$. To find a generator, we can choose a
value and test it like so:

- compute all the distinct prime factors of $p-1$, denoted $f_1, f_2 ... f_r$

- g is a generator as long as $g^{\frac{(p-1)}{f_i}} \neq 1 \mod p$, for  $i = 1,2,..,r$

Should you be tasked to find the order of a generator for $\mathbb{Z}_n^*$ where _n_ is not prime
you need to factorize _n_ into its prime factors _pq_ and then use the rule\
$|g| = (p-1)(q-1)$\
to find the order.

For example: (from exam 2018)\

> a generator for $\mathbb{Z}_{15}^*$ has order:\
> (a) 1\
> (b) 3\
> (c) 8\
> (d) 14\

15 consists of the prime factors 3 and 5. The order of the generator must be $(3-1)*(5-1) = 8$.

## Example of determining if a number is a generator for $\mathbb{Z}_p^*$
- $p = 7$
- $\mathbb{Z}_7^*$ has a generator $g = 4$ if the test holds.
- 4 has just one prime factor, 2.
- $g^{\frac{6}{2}} \neq 1$
- This means that $g = 4$ is not a generator for $\mathbb{Z}_7^*$

##  Fields
> a field is a set, F, with two binary operations
$+$ and  $\cdot$, satisfying:

1. F is commutative group under the + operation, with identity element denoted 0
2. F \\ {0} is a commutative group under the dot operation
3. distributive, $\forall (a,b,c) \in F$

### Finite fields GF(p)
For secure communications, we only care about fields with a finite number of elements. \
a famous theorem says that
> Finite fields exist of size p^n for any prime
jesus christ hun dama går fort frem.
See slides from lecture 2

- often written $Z_p$,instead of GF(p)
- multiplication and a addition are done modulo p
- Multiplicative group is exactly $Z_p^*$
- used in digital signature schemes

For finite fields of order $2^n$ can use polynomial arithmetic: \
$00101101 = x^5 + x^3 + x^2 + 1$
\
the field is represented by use of a primitive polynomial m(x).
Addition and multiplication is defined by polynomial addition and multiplication modulo m(x).
Division is done efficiently by hardware using shifts.
