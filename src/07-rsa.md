# RSA

## Keys

Keys consist of several numbers. You need two random, distinct primes, _p_ and _q_, the product of these
called the modulus, _n_, a public exponent, _e_ and a private exponent, _d_. \
After choosing two primes of satisfying size, _p_ and _q_, multiply these to attain _n_. The size
should be at least 1024 bits by todays standards (according to slides.).

Next up is _e_. It only needs to satisfy $gcd(e,\phi(n)) = 1$. 3 is the smallest possible value, and is
sometimes used. Not recommended as it might introduce security problems. However,
65537 ($2^{16}+1$, or $2^{2^4}$) is a popular choice. Since it is prime (largest known prime on the
form $2^{2^{n}}+1$, called a fermat prime), it satisfies the equation for every _n_ and does not require
any additional checking. As an added bonus, this number has just two set bits in binary
(`10000000000000001`). This makes it an easy number to perform arithmetic on.

_d_ is computed as $e^{-1}mod(\phi(n))$.\

These values make up for the private and public keys for RSA encryption. _n_ and _e_ is the public
key, written as $K_E = (n,e)$. _p_, _q_ and _d_ is the private key, written as $K_D = d$. The values
_p_ and _q_ are not used directly in encryption or decryption.

Note that the equation for _e_, given _n_ and _d_ is similar to the equation for _d_:\
$d = e^{-1}mod(\phi(n))$.\
$e = d^{-1}mod(\phi(n))$.

Might be useful for an exam.

## Encryption

The input of the encryption is called _M_, which is a value that is less than _n_.\
$0 < M < n$\
in order for a message to become _M_, it needs to be preprocessed by encoding letters to numbers,
as well as adding randomness.

The ciphertext, _C_, is computed as $E(M,K_E) = M^e \mod n$

## Decryption

The plaintext is retrieved by computing $D(C, K_D) = C^d \mod n = M$.\
RSA decryption can be done more efficiently by utilizing the chinese remainder theorem. Good luck to
you, I dont know math.\
It achieves up to 4 times speed up sequentially, or 8 times if it is ran in parallell. Because of
optimizations like this, you generally want to keep _p_ and _q_ instead of discarding them after
generating them -- even though they aren't strictly needed for encryption or decryption.

## Example (stolen from slides)

not using chinese remainder theorem.\
let _p_ = 43, _q_ = 59.\
This means _n_ = _pq_ = 2537 and $\phi(n) = (p-1)(q-1) = 2436$.\
let _e_ = 5. We assume whoever wrote the slides have checked whether 5 satisfies the equation for _e_\
This means $d = e^{-1}\mod(\phi(n)) = 5^{-1}\mod(2436) = 1949$. (by calculating the
modular inverse, which totally sucks ass).\
Assuming an already preprocessed message, _M_, with the value 50, the encryption process looks
like:\
$C = M^e\mod (n) = M^5\mod(2537) = 2488$.

Likewise, decryption looks like this:\
$M = C^d \mod(n) = C^{1949}\mod(2537) = 50$.

Note how only publicly known values are used in encryption, while decryption uses the private
exponent.

## preprocessing/padding messages
Just encoding each letter to a number offers weak security. This can be observed to create an attack
dictionary, or even for a `known plaintext attack`. `Håstads attack` is also a thing, which is described later.
To prevent this, we preprocess the messages by padding to prepare the messages for encryption.
These mechanisms must include redundancy and randomness.

### PKCS number 1

|    |    |     |    |   |
|----|----|-----|----|---|
| 00 | 02 | PS  | 00 | D |

: encryption block format

- 00 is a byte
- 02 is a byte
- PS is a string of non-zero, pseudo random bytes. Minimum 8 bytes long.
- D is the data to be encrypted. This is the same length as the modulus, _n_.

Using this scheme ensure that even short messages result in a big number for encryption.

### Optimal Asymmetric Encryption Padding (OAEP)
OAEP is an encoding scheme that is a feistel network. It includes $k_0$ bits of randomness and $k_1$
bits of redundancy. It also features the use of two hash functions in the network. This means that
small changes in any bit going into the hash functions drastically alters the output. Because of
this we say that the scheme features an "all or nothing" security. This means that in order to
recover the message, you also need to recover the complete random string included.

Not sure if the algorithm is a big part of the curriculum. So it is left out for now.

Key points:

1. it pads the input to achieve the same as PKCS #1
2. It includes randomness and redundancy
3. because of the hash functions ("all or nothing"), partial messages or other information will not be leaked
4. provides security against chosen ciphertext attacks  (and possibly chosen plaintext, not 100%
   sure)

## Attacks against RSA
A properly set up RSA scheme has pretty good security. Many proposed attacks on RSA are avoided by
using standardised padding schemes.

The best known attack against RSA is factorization of _n_, which
is a hard problem. The attack is prevented by choosing a large enough _n_.

Another candidate is to find the private key from the public key. It is supposedly not
feasible, and at least as hard as factorizing _n_.

Other possibilities are the use of quantum computers, which do not exist yet, and timing attacks,
which have countermeasures.

It is an open problem whether it is possible to crack RSA without factorizing _n_.

In other words, the biggest flaw of RSA isn't the algorithm itself. Key generation flaws due to poor
random number generation is often the culprit.
