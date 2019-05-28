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

## Discrete logarithm signatures







