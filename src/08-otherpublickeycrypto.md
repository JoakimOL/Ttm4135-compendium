# Diffie-Hellman key exchange {#sec:DiffieHellman}

## Motivation

Discrete log based ciphers are currently the main alternative public key systems, other than RSA.

> Designed to allow two users, Alice and Bob, to share a secret using only public communications.

Public knowledge includes:

- Large prime, _p_
- generator g of $\mathbb{Z}_p^*$

## Basic protocol {#sec:diffiehellman:protocol}

Alice chooses  _a_ $\in \mathbb{Z}_p^*$ and sends $K_a = g^a \mod p$ to Bob.
Next, Bob chooses _b_ $\in \mathbb{Z}_p^*$ and sends $K_b = g^b \mod p$ to Alice.

_a_ and _b_ must satisfy $0 < a,b < p-1$.

Now both have knowledge of a $Z = (g^b)^a \mod p$. _Z_ can be used to compute a key for various
crypto schemes. It is secure, as the only numbers that are being broadcast are $g^a \mod p$ and
$g^b \mod p$. To find _a_ and _b_ from this you'd need to solve the discrete logarithm problem, which is hard.

It is rather easy to set up a man in the middle attack for this scheme. Just have the adversary set
up keys with both Alice and Bob, and just relay the messages using these keys. Alice and Bob
shouldn't be any wiser.

Alice thinks she sends message to Bob, is in reality sending to malicious attacker who constructs
$K_{ac}$. The attacker does the same with Bob and constructs $K_{bc}$. If Alice wants to send
something to Bob, it goes through the attacker using $K_{ac}$ and is passed onto Bob using $K_{bc}$.

Alice and Bob cannot in reality send messages directly to each other, it has to go through the man in
the middle, which can read everything thanks to the keys.

This is fixed by adding digital signatures, see @sec:digitalsignaures for details on the signatures.
The authenticated Diffie-Hellman that fixes this problem is shown in @sec:keys:authDH.

## static and ephemeral Diffie-Hellman{#sec:diffiehellman:staticephemeral}
The protocol described above uses _ephemeral keys_: Keys which are used once and then discarded. In
a static Diffie-Hellman scheme you'd let each party choose a long-term private key $X_a$ with
corresponding key $Y_a = g^{x_a} \mod p$. If each party has a long term key, they can simply look up
each others keys and possibly skip the initial handshake.

# Elgamal cryptosystem{#sec:elgamal}
> Turning the Diffie-Hellman protocol into a cryptosystem since 1985

Based on one party having ephemeral keys, while the other has a long-term key. The long-term key
works like a public key, while the ephemeral keys are private

Key generation:

- Select a prime _p_ and a generator g of $\mathbb{Z}_p^*$
- select a long term private key _x_ where $0 < x < p-1$ and compute $y = g^x \mod p$
- The public key is (p, g, y)

Encryption: \
The public key for encryption is $K_E = (p,g,y)$

1. for any value (message) _M_, where $0 < M < p$
2. choose _k_ at random, and compute $g^k \mod p$

3. $C = E(M,K_E) = (g^k \mod p, My^k\mod p)$


Decryption: \
The private key for encryption is $K_D = x$ with $y = g^x \mod p$

1. let $C = (C_1, C_2)$
2. $D(C_1,K_D) = C_2 \cdot (C_1^x)^{-1} \mod p = M$


## Why does it work?{#sec:elgamal:why}
The sender knows the ephemeral private key _k_.
The receiver knows the static private key _x_.
Both sender and recipient can compute the Diffie-Hellman value for the two public keys $C_1 = g^k
\mod p$ and $y =g^x \mod p$. The value $y^k \mod p = C_1^x \mod p$ is used as a mask for the message
_m_ that pushes the value to another value in that group.


## Security of Elgamal{#sec:elgamal:security}
The whole system is based on the difficulty of the discrete logarithm problem. If you can solve this
problem and find x from $g^x \mod p$, the system is broken.
Does not need padding, and does not require unique keys for every user.

# Elliptic curves{#sec:EC}
> Elliptic curves are algebraic structures formed from cubic equations.
> But hey, we won't be using elliptic curves in the reals.
-Cris Carr

For example:\
The set of all $(x,y)$ pairs which satisfy the equation $y^2  = x^3 + ax +b \mod p$. This is a curve
over the field $\mathbb{Z}_p$. Elliptic curves can be defined over any field.

Adding an identity element makes it possible to define binary operations on these curves. Doing so
defines elliptic groups.

The discrete log problem can be defined on elliptic curve groups, with the same definition if we
define the elliptic curve group with multiplication. The best known algorithm to solve the elliptic
curve discrete logarithm problem are exponential with the length of the parameters. Because of this,
most elliptic curve implementations use much smaller keys. If we compare this to RSA, the relative
advantage of elliptic curve cryptography will increase at higher security levels.

We can use elliptic curves in several cryptosystems, like the Diffie-Hellman key exchange
and elgamal.


# Identity-based cryptography
TODO\
See lecture 9

