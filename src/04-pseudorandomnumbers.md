
# Pseudo random numbers and stream ciphers

> Random values are important, and are the building blocks of stream ciphers.

## Random numbers
Defining randomness is hard. We would like to get bitstrings that just as random as any other.

Generators of random numbers are divided into categories:

- True random number generators (TRNG)
    - Physical processes which outputs each valid string independently with equal probability
- Pseudo random number generator (PRNG)
    - A deterministic algorithm made to approximate a true random number generator


## True random number generators
NIST has provided a framework for design and validation of TRNGs, called entropy sources. These
entropy sources includes a physical source of noise, a sampling process and post processing. The
output is any requested number of bits. The standard specified by NIST also includes statistical
tests for validating the entropy sources.

## Pseudo randon number generators
NIST recommends specific PRNG algorithms named Deterministic random bit generators (DRBG), based on hash
functions, HMAC and block ciphers in counter mode ( see lec 3 ). They often use a TRNG to seed the
state.

## security of a DRBG
The security is defined in terms of the ability of an attacker to distinguish between a PRNG and
TRNG. This is measured by two properties:

1.  Backtracking resistance
    - An attacker who knows the current state of the DRBG cannot distinguish between earlier
      outputs.
    - If you see one output, you cannot make sense of, or guess, earlier outputs?
2. forward prediction resistance
    - An attacker who knows the current state of the DRBG should not be able to distinguish between
      later states and the current.


## CTR_DRBG
Uses a block cipher in CTR mode (see lec. 3), such as AES with 128bit keys.
The DRBG is initialized with a seed which matches the length of the key and block summed.  This seed
defines a key, _k_ , which is used in AES. No nonce and CTR value is used, like in normal CTR mode,
but rather uses the seed value.

### update function in CTR_DRBG
Each request to the DRBG generates of up $2^{19}$ bits.
State must be updated after each request, which is handled by the update function. (K,ctr) must be
updated by generating two blocks using the old key to make a new one.

## Stream ciphers
> Stream ciphers are characterise by the generation of a keystream using a short key and an init
> value as input

Each element of the stream is used successively to encrypt one or more plaintext characters.

Symmetric. Given the same key value, both sender and receiver can encrypt and decrypt the same.

### Synchronous stream ciphers
Simplest kind of stream ciphers, as the keystream is generated independently of the plaintext. Both
sender and receiver nee the same keystream, and synchronise their position in it. In a way, one can
look at the vigenere cipher as a periodic synchronous stream cipher where each shift is defined by a
key letter.

### Binary synchronous stream cipher
For each time interval, _t_, each of the following are defined:

- A binary sequence, $s(t)$, called the keystream
- a binary plaintext $p(t)$
- a binary ciphertext $c(t)$

Encryption: $c(t) = p(t) \oplus s(t)$

Decryption: $p(t) = c(t) \oplus s(t)$


## Shannon's definition of perfect secrecy
> to define perfect secrecy, consider a cipher with message set _M_ and ciphertext set _C_.
> Then $PR(M_i|C_j)$ is the probability that the message $M_i$ was encrypted given that ciphertext
> $C_i$ is observed.
> The cipher achieves perfect secrecy if for all messages and ciphertexts that
> $Pr(M_i | C_i ) == Pr(M_i)$

If we cannot tell whether the message is encrypted with one key or another, and everything is just
complete bullshittery guessing - it is a perfect secret.

## One time pad using roman alphabet example
Plaintext: HELLO

Keystream: EZABD

Ciphertext: LDLMR


Since the probability of each character in he keystream is equally plausible, the 5-letter ciphertext
can equally possibly be every 5-letter string.


### One time pad properties
Any cipher with perfect secrecy must have as many keys as there are messages.
In a sense, it is the only unbreakable cipher. But it suffers from key management problems and
actually getting completely random keys. Key generations, transportation, sync, destruction and
problematic since the keys are possibly very large.

## Visual cryptography
> An application of the one time pad is visual cryptography which  splits an image into two shares
> Decryption works by overlaying the two shared images

Works by splitting the pixel in a random way, just like splitting a bit in the one time pad. Each
split doesn't reveal any info about the image, again alike the one time pad.

Encrypting an image:

- generate the one time pad, _P_, (random string of bits), with length equal to the number of pixels
  in the image
- Generate an image share, $S_1$, by replacing each bit in the random bitstring by using some sub
  pixel patterns.
- Generate the other image share, $S_2$, with pixels as follows:
    - The same as $S_1$ for all white pixels of the image
    - The opposite for all black pixels.



To reveal the hidden images, the two shares are overlaid. Each black pixel is black in the overlay,
each white pixel is half-white in the overlay.


## Conclusion
TRNGS can be constructed from physical devices and used as seeds.
PRNGs can be constructed from other primitives like block ciphers.
TRNGs can be use to make unbreakable encryption via one time pad.
PRNGs can be use as practical synchronous stream ciphers





