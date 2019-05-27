# Block ciphers

> Block ciphers are the main bulk encryption algorithms used in commercial applications.

`Block cipers` are `symmetric key ciphers`, where the plain text is divided into blocks. Each block is
encrypted/decrypted using the same key. A block is of a fixed size, often between 64 and 256 bits.
Block ciphers are used in certain ways, called `modes of operations`. Each mode has different
properties that make them desirable/undesirable in certain applications.

## Notation

 - the message is n blocks in length
 - P Plaintext
 - C Ciphertxtt
 - K Key
 - E Encryption function
 - D Decryption function
 - $W_i$ Block i
 - $P_i$ plaintext block i
 - $C_i$ ciphertext block i

## Criteria for block cipher design

Claude Shannon discussed two important properties of encryption:

1. Confusion
    - Making the relation between the key and ciphertext as complex as possible
2. Diffusion
    - Dissipate the statistical properties of the plaintext in the ciphertext (letter frequencies
      etc.)

Shannon proposed to use these techniques repeatedly using the concept of `product cipher`

Good block ciphers exihibit a socalled avalanche effect. Both a `key avalanche` and a `plaintext
avalanche` is wanted, according to Shannons properties mentioned above.\
A key avalanche is where a
small change in the key results in a big change in ciphertext. This relates to Shannons notion of
confusion. Try encrypting the same text using a simple substitution cipher and then swap two
characters in the key. Observe small changes in ciphertext. Next, try doing the same using a more
sophisticated encryption scheme like AES with an online tool. Observe a huge difference after
altering key.\
A plaintext avalanche is when a small change in plaintext results in a big change in the ciphertext.
Ideally we'd like each bit to have a 50% probability to flip. This is related to Shannons notion of
diffusion. Try encrypting the same text using a simple substitution cipher and then change one letter in the plaintext. Observe small changes in ciphertext. Next, try doing the same using a more sophisticated encryption scheme like AES with an online tool. Observe a huge difference after altering the plaintext.\


## Product cipher

> A product cipher is a cryptosystem in which the encryption function is formed by composing several
> sub-encryption functions

Most block ciphers compose simple functions, each with different keys.

$C = E(P,K) = f_r (...  (f_2(f_1(P,K_1),K_2)...), K_r)$

## Iterated cipher
A special class of product ciphers are called iterated ciphers.
The encryption process in an iterated cipher is divded into $r$ similar `rounds`, and the
sub-encryption functions are all the same function, _g_, called the `round function`.
Each key, $K_i$, is derived from the `master key`, _K_. Each key $K_i$ are called `round keys` or
`subkeys` and are derived using a process called the `key schedule`.

### Encryption in interated ciphers
$W_0 = P$\
$W_1 = g(W_0, K_1)$\
$W_2 = g(W_1, K_2)$\
$... ... ...$\
$W_r = g(W_{r-1}, K_r)$\
$C = W_r$\

### Decryption in interated ciphers
in order to decrypt the messages, an inverse of the round function, $g^{-1}$, must be available.
the inverse must satisfy
$g^{-1}(g(W,K_i),K_i) = W$, $\forall K_i, W$

## Feistel ciphers
Feistel ciphers are iterated ciphers where the round function swaps two halves of the block and
forms a new half on the right side.

Encryption is done in three steps:

1. Split the block into two halves: $W_0 = (L_0, R_0)$
2. For each of the _r_ rounds, do:\
$L_i = R_{i-1}$\
$R_i = L_{i-1} \oplus f(R_{i-1},K_i)$\
Where _f_ is any function, note that choice of _f_ affects security
3. Ciphertext is $C=W_r = (L_r,R_r)$.

## Substitution-permutation network
Substitution-permutation networks (SPNs) are iterated ciphers. They require the block length, _n_ to
allow each block to be split into _m_ sub-blocks of length _l_, so that $n = lm$ (The block length
must allow you to split it into _m_ equally long sub-blocks). SPNs define two
operations:

1. Substitution, $\pi_s$, operates on sub-blocks of size _l_ bits: \
$\pi_s : \{0,1\}^l \rightarrow \{0,1\}^l$ \
The permutation $\pi_s$ is usually called an S-Box(substitution box)

2. Permutation, $\pi_p$, swaps  the inputs from $\{1, ... , n\}$. This is similar to the transposition
   cipher.\
   $\pi_p : \{1,2, ..., n\} \rightarrow \{1,2, ... , n\}$

During the round function _g_ of an SPN, there are three steps:

1. The round key $K_i$ is `XOR`ed with the current block $W_i$.
2. Each sub-block is substituted by using substitution ($pi_s$)
3. The whole block $W_i$ is permuted using permutation ($pi_p$)

## DES
> TODO

## AES
Data blocks are always 128 bits, while the key length (and number of rounds) may vary. Supports 128,
192 and 256bit master key lengths, each requiring 10, 12 or 14 rounds respectively.  This makes it a substitution-permutation network with _n_ = 128 and _l_ = 8.
The structure of the AES cipher is a byte-based substitution-permutation network consisting of:

1. initial round key addition (only AddRoundKey stage)
2. (number of rounds - 1) rounds
3. final round. (no MixColumn stage)

AES represents each block as a 4x4 matrix of bytes (128 bits = 16 bytes, which is the reason for the fixed block size), and performs both finite field operations in $GF(2^8)$ and bit string operations:

1. ByteSub (non-linear `substitution`)
    - Using a predefined lookup table (S-box), substitute each matrix cell.
2. ShiftRow (`Permutation, Diffusion`)
    - Leave top row as is.
    - Second row is shifted by 1 byte (AA,BB,CC,DD $\rightarrow$ BB,CC,DD,AA)
    - third row is shifted by 2 bytes
    - fourth row is shifted by 3 bytes
3. MixColumn (Diffusion)
    - For every column multiply by, in the field, a predetermined matrix.
4. AddRoundKey
    - For every column, XOR with corresponding column of round key $K_i$

### Key schedule
The keys are also represented as a 4x4 matrix, similar to the blocks. This requires a 128bit subkey
to be used in every round. These subkeys are derived from the master key. You'll need (number of
rounds + 1) subkeys in total (since you need an initial subkey for the initial round).

### Security in AES
No severely dangerous attacks are known yet. If you reduce the number of rounds, security decreases.
If an attacker gets hold of cipher text encrypted with a key that has a special relation to the
master key, a related key attack is possible. What is a related key attack? this course doesn't
know.


# Block cipher modes of operation

## Motivation
Block ciphers encrypt blocks, but many of them are encrypted sequentially. This is generally
insecure. Using different standardised _modes of operation_ with different levels of security and
efficiency. This can also be used for authentication and integrity.

### Randomized encryption
We can see patterns if the schemes arent random. Typically this is achieved using an initialization
vector IV, which may need to be either random or unique. One can also use a state variable that
changes.

### Efficiency
There are several features of the modes that affect its efficiency. These do not affect seccurity,
but we would like to encrypt our data before the millennia is over. Features like possibility of
parrallell processing etc.

### Padding
some modes require the plantext to consist of only whole blocks. If the plaintext is not a length
that is divisible by block length you will need to pad the plaintext to get the desired length.

## Confidentiality modes

### Electronic Codebook mode (ECB)
This is dumb because you just take each block, and apply E or D to it using the same key every
time.

- Not randomised.
- Padding required.
- We can do parallell encryption/decryption though.
- Errors propagate within blocks.
- No initialization vector IV.

### Cipher block chaining mode (CBC)
CBC "chains" the blocks together.

Encryption: $C_t = E(P_t \oplus C_{t-1},k) where C_0 = IV$

Decryption: $C_t = D(C_t, k) \oplus  C_t-1, where C_0 = IV$

- randomised.
- Padding required.
- Errors propagate within blocks and to specific bits of next blocks
- We can do parallell decryption, no encryption.
- IV must be random

### Counter mode (CTR)

A counter and nounce is used. They are initialized by a randomly chosen value N. T_t is the
concatenation between the nonce and block number t, N||t.
$O_t  = E(T_t, k)$

This is XORed with the plaintext block.

Encryption: $C_t = O_t \oplus P_t$

Decryption: $P_t = O_t \oplus C_t$

A one bit change in the ciphertext produces a one bit error in the plaintext at the same location

- randomised.
- Padding not required.
- Errors occur in specific bits of the current block
- both parallell encryption and decryption
- Variable, nonce, which must be unique

Good for accessing specific plaintext blocks without decrypting the whole stream.

## Message integrity
How to ensure that the message is not altered in the transmission? We treat message integrity and
message authentication as the same thing. This includes preventing an adversary from fucking with
your blocks. Message integrity can be provided whether or not encrpytion is used for
confidentiality.

### Message Authentication Code (MAC)

A mechanism for ensuring message integrity.
On input secret key, _K_ , and an arbitrary length message _M_, a MAC algorithm otuts a short
fixed-length string, _T_, known as the tag.

$T = MAC(M,K)$

Two entities _A_ and _B_ share a common key _K_, and _A_ wants to send message, _M_, to _B_.

 - _A_ computes the tag
 - _A_ sends the message _M_ and also the tag.
 - _B_ recomputes the tag on the received message and checks if the new tag and received tag are
   equal.

This provides sender authentication to the message, since only _A_ and _B_ knows the key, and are
thus the only ones that can produce the tag, _T_.
If _A_ and _B_ makes two different tags, _B_ must conclude that shit happened and the message is
fiddled with. If the tags are the same, all is good.

This basic property is called `unforgeability`. It is not feasible to produce a message, _M_, and a
tag, _T_, such that $T=MAC(M,K)$ without knowing the key, _K_. This includes the scenario where the
attacker has access to a `forging oracle`, which means that the attacker can insert any message to a
function and get the corresponding tag out. (chosen plaintext attacks)

It is not feasible for an attacker to produce a valid forgery.

### Basic CBC-MAC (CMAC)
we've only discussed the properties of a MAC, not how the tag is created. CMAC is one way of
creating a tag, using a block cipher. This is unforgeable as long as the message length is fixed.

let _M_ be the message consisting of _n_ blocks. To compute CBC-MAC(_M_,_k_), do:\

\begin{algorithm}[H]
\DontPrintSemicolon
\SetAlgoLined
\SetKwInOut{Input}{Input}\SetKwInOut{Output}{Output}
\Input{Message M, initialization vector IV, Key K}
\Output{CMAC tag}
\BlankLine
    \For{$t\gets1$ \KwTo $n$}{
        ${C_t} = E({M_t} \oplus C{t-1}, K)$, where $C_0 = IV$
    }
\Return $T=C_t$
\caption{CBC-MAC}
\end{algorithm}

Note that unlike the CBC-mode, the IV has to be fixed and public. A random IV is not secure in
this application. _E_ is defined as the encryption for CBC-mode, see CBC-section.

### standardized CBC-MAC
A secure version of CMAC is standardized with some changes from the basic version:

- The original key, _K_, is used to derive two new keys, $K_1$ and $K_2$.
- One is used in the basic algorithm, the other is XORed into the final message block. Pad if neccessary.
- The IV is set to all zeroes.
- The MAC tag is the $T_{len}$ most significant bits of the output.

Choice of $T_{len}$ depends on the degree of security needed. The standard states that 64 bits lets
most applications resist guessing attacks. More generally, the standard states that the tag should
be at least $log_2 \frac{I}{R}$ bits long, where _I_ is how many invalid messages that can be
detected before you change the key and _R_ is the accepted risk that a false message is accepted.


