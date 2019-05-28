# More number theory for public key cryptography.

## Chinese remainder theorem

>let _d1_, ... ,_dr_, be pairwise relatively prime and n = d1,d2, ... , dr, given any integers $c_i$ there
> exists a unique integer x with $0 \leq x < n$ such that
>
> $x \equiv c_1  (\mod d_1)$
>
> $x \equiv c_2  (\mod d_2)$
>
> $x \equiv c_3  (\mod d_3)$
>
> ...
>
> $x \equiv c_r  (\mod d_r)$

### Exam question example using chinese remainder theorem:\
Given a set of equations on the form $x_i \equiv y_i (\mod z_i)$\
Like stated above, the Chinese remainder theorem can only be used if the set $Z = (z_1, ... ,z_n)$ are pairwise coprime.

Example from exam 2018:

> Which of the following pairs of equations can be solved using the chinese remainder theorem?\
> (a) $x \equiv 3 (\mod 6)$ and $x \equiv 4 (\mod 8)$\
> (b) $x \equiv 3 (\mod 6)$ and $x \equiv 4 (\mod 10)$\
> (c) $x \equiv 3 (\mod 7)$ and $x \equiv 4 (\mod 12)$\
> (d) $x \equiv 3 (\mod 7)$ and $x \equiv 4 (\mod 14)$

Looking at the _z_ values (the moduluses), we see that only 7 and 12 are coprime (answer c).\
the other options are divisible by 2 (6 and 8, 6 and 10) or a factor of each other (7 and 14).

## Euler function $\phi$
> For a positive integer _n_, the euler function $\phi(n)$  denotes the number of positive integers
> less than _n_ and relatively prime to _n_.

For example: $\phi(10) = 4$ since 1,3,7,9 are each relatively prime to 10 and less than 10.
The set of positive integers less than n and relatively prime to n form the reduced residue class $\mathbb{Z}_n^*$
$\mathbb{Z}_n^* = {1,3,7,9}$

### properties of the euler function $\phi(n)$

1. $\phi(p) = p-1$ for p prime
2. $\phi(pq) = (p-1)(q-1)$ for p and q distinct primes
3. let $n = p_1^{e_1} ... p_t^{e_t}$ where $p_i$ are distinct primes. Then $\phi(n) = \prod
   p_i^{e_1-1}(p_i-1)$ (generalization of point 2)

Example:

$\phi(15) = \phi(5)* \phi(3) = (5-1)*(3-1) =  4 * 2 = 8$

$\phi(24) = 2^2(2-1)3^0(3-1) = 8$

(where $24 = 2^3 * 3$)

## Fermat's theorem
> let p be a prime, then $a^{p-1} \mod  p = 1$, for all integers _a_ with $1 < a \leq p-1$.

## Euler's theorem
> $a^{\phi(n)} \mod n = 1$, if $gcd(a,n) = 1$.

When _p_ is prime then $\phi(p) = p-1$, so Fermat's theorem is a special case of Euler's theorem


## Discrete logarithm problem
> let _g_ be    a generator for $\mathbb{Z}_p^*$ for a prime p. The discrete log problem is: \
> given y in $\mathbb{Z}_p^*$ find x with $y=g^x \mod p$.

If _p_ is large enough, this is believed to be a hard problem. Usually RSA-length, 2048 bits.

$log_x g^x = x log_g g = x$





