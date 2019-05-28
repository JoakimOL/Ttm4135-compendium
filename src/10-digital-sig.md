# Digital signatures
MACs provide data integrity and authentication (is the data tampered with? is the person you're
interacting with who he/she claims?). Generating a MAC tag requires the message, as well as the key.
Digital signature provides all the same properties, as well as a few additions. It is a technique
that uses `public key` cryptography. Digital signatures provide non-repudiation, which is a legal
concept. That means you can say your key was lost to a hacker and whatever malicious actions that
key was involved with was not your work.

## Elements of a digital signature scheme

1. Key generation
    - Outputs two keys, `signature generation key`, $K_s$, and `signature verification key`, $K_v$.
2. Signature generation
    - outputs a signature, _s_, given a message and a signing key.
3. Signature verification
    - outputs a boolean, given a message, a verification key and a signature.


### signature generation algorithm
Only the owner of the signing key (signature generation key) should be able to generate a valid
signature for any message.

\begin{algorithm}[H]
\DontPrintSemicolon
\SetAlgoLined
\SetKwInOut{Input}{Input}\SetKwInOut{Output}{Output}
\Input{Message m, signing key $K_s$}
\Output{Signature s}
\caption{Signature generation}
\end{algorithm}

### signature verification algorithm
Anyone should  be able to use the signature verification key to verify a signature.

\begin{algorithm}[H]
\DontPrintSemicolon
\SetAlgoLined
\SetKwInOut{Input}{Input}\SetKwInOut{Output}{Output}
\Input{Message m, Verification Key $K_v$, Signature s}
\Output{boolean}
\caption{Signature verification}
\end{algorithm}

The verifying function should always return true for matching signing/verification keys (correctness property).\
It should be infeasible for anyone without $K_s$ to construct _m_ and _s_ such that the
verification returns true.

## Security goals
digital signatures may be broken in different ways

- Key recovery:
    - Recovering the private key from the public key and some known signatures
- selective forgery:
    - The attacker chooses a message and attempts to obtain a signature on that message
- existential forgery:
    - The attacker attempts to forge a signature on any message not previously signed.

Modern digital signatures are only considered secure if they can resist existential forgery under a
`chosen plaintext attack`.

## RSA signatures
One way of generating digital signature keys is by using RSA. Just like in the encryption scheme,
RSA signatures rely on the difficulty of factorizing primes.

The public verification key becomes (_e_,_n_), where _n_ = _pq_. The signing key is _d_. RSA
signatures also require a hash function, _h_, which should be a fixed and publicly known parameter of the
scheme. The choice hash function is important, as some allow you to prove your security. a full
domain hash function (can output all values between 1 to _n_) or `PSS` are good choices.

Signature generation takes the message  _m_, the modulus _n_ and the private exponent _d_ as input.
The signature _s_ is computed as $h(m)^d\mod n$.

Signature verification takes the signature and the public key _e_ as input. If $s^e \mod n =
h\prime$ the signature is legit.

## Elgamal signature scheme in $\mathbb{Z}_p^*$
Signature scheme based on the discrete logarithm problem. It consists of the following keys, given
_p_, a large prime with generator _g_:

1. Private signing key, _x_, where $0 < x < p-1$.
2. Public key, $y = g^x \mod p$, where _y_, _p_ and _g_ are public knowledge.

Signature generation:

1. Select random _k_ such that $gcd(k,p-1) = 1$ and compute\
$r = g^k \mod p$
2. Solve equation $s = k^{-1}(m - xr) \mod (p-1)$
3. return (m, r, s)

Signature verification:

1. verify that $g^m \equiv y^r r^s (\mod p)$


## Digital signature algorithm (DSA)
Based on the elgamal signature scheme, but with simpler calculations and shorter signatures. This is
due to restricting calculations to a smaller group or to an elliptic curve group.

It is also designed to use with a SHA hash function. Avoids some attacks Elgamal signatures may be
vulnerable to.

The prime, _p_, is chosen such that p - 1 has a prime divisor, _q_. The sizes of _p_ and _q_ are
denoted _L_ and _P_, respectively. Note how the size of _q_ is much smaller than _p_. The generator, _g_,
is replaced with the value $h^{\frac{p-1}{q}} \mod p$, where _h_ is a generator of $\mathbb{Z}_p^*$. This implies
that _g_ has order _q_, which in turn means that all exponents in the algorithm can be
reduced modulo _q_ before exponentation -- saving precious computation power.


| L           | N            | to use with |
| ----------- | ------------ | ----------- |
| 1024 bits   | 160 bits     | SHA-1       |
| 2048 bits   | 224 bits     | SHA-224     |
| 2048 bits   | 256 bits     | SHA-256     |
| 3072 bits   | 256 bits     | SHA-256     |

: valid combinations of L and N in DSA. Some NIST publication does not approve the first choice of
parameters.

keys:

1. Private signing key, _x_, where $0 < x < q$.
2. Public key, $y = g^x \mod p$, where _y_, _p_ and _g_ are public knowledge.

Signature generation:

1. Select random _k_ such that $0 < k < q$ and compute\
$r = g^k \mod q$
2. Solve equation $s = k^{-1}(H(m) - xr) \mod (q)$, where _H_ is a SHA-family hash function that
   outputs _N_ bits
3. return (m, r, s)

The returned signature is of size 2N bits.

Signature verification:

1. check that $0 <  r < q$ and $0 < s q$
2. compute $w = s^{-1} \mod q$,\
$u_1  = H(m)w \mod q$\
$u_2  = rw \mod q$
2. verify that $(g^{u_1}y^{-u_2} \mod p) \mod q = r$

## Elliptic curve DSA (ECDSA)
Elliptic curve parameters are chosen from a list of NIST approved curves.\
Signature generation and verification is the same as in DSA with a few exceptions:

1. _q_ becomes the order of the elliptic curve group.
2. multiplication mod _p_ is replaced by the elliptic curve group operation $\cdot$.
3. after each operation on a group element, only the x-coordinate is kept.

Signatures generated from ECDSA is generally not shorter than DSA with the same security level.
ECDSA signature sizes can vary form 326 to 1142 bits (while DSA signatures are often 448 or 512
bits).

ECDSA have shorter public keys.


