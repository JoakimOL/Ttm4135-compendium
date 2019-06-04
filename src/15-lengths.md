# Comparisons and summaries

Smallest acceptable key length to prevent exhaustive key search = 256 bits

| symmetric key length | RSA key length | Elliptic curve key length  |
| -------------------- | ------------   | -------------------------- |
| 80 bits              | 1024 bits      | 160                        |
| 128 bits             | 3072 bits      | 256                        |
| 192 bits             | 7680 bits      | 384                        |
| 256 bits             | 15360 bits     | 512                        |

: different key lengths in different schemes with same security rating


|                | AES                 | DES              |
| -------------- | ------------------- | -----------      |
| key length     | 128,192,256 bits    | 56 bits          |
| block length   | 128 bits            | 64 bits          |
| output length  | depends on mode*    | depends on mode* |

: comparison of symmetric/shared key encryption schemes

if mode uses padding scheme: output is a multiple of block length. If not, it is equal to
plaintext length

|                    | RSA                            | Elgamal                     |
| ------------------ | ----------                     | ------------                |
| public key length  | size of n and d: $n + \phi(n)$ | size of p,g,y: $p + 2(p-1)$ |
| private key length | size of e: $\phi(n)$           | size of x: p-1              |
| output length      | n                              | 2*p                         |

: comparison of asymmetric/public key encryption schemes
size of g,y,x is p-1 because their domain is 1 < g,y,x < p\
(Possibly obvious exam note: if p and n are of the same size, Elgamal produces a cipher text that is
twice as long as RSA. Exam may 2016)


| property              | EBC               | CBC                                          | CTR                         |
| --------------------- | ----------------- | -------------------------------------------- | --------------------------- |
| randomized            | no                | yes                                          | yes                         |
| padding               | yes               | yes                                          | no                          |
| error propagation     | within same block | within same block and specific bits of next  | specific bits of same block |
| IV                    | no                | must be random                               | nonce must be unique        |
| parallell encryption  | yes               | no                                           | yes                         |
| parallell decryption  | yes               | yes                                          | yes                         |

:overview of block cipher modes

| scheme            | property                                                                           |
| -------           | --------                                                                           |
| RSA signature     | Fast signature verification, shorter signature than elgamal, longer than DSA/ECDSA |
| Elgamal signature | Pretty bad compared to the others                                                  |
| DSA               | short signatures 2N bits, faster than elgamal, faster generation than RSA          |
| ECDSA             | short public keys, often longer signatures than DSA                                |

:overview of digital signature properties


|             | Hash size   | Block Size   |
| ----        | ----------- | ------------ |
| MD5         | 128 bits    | 512 bits     |
| SHA-1       | 160 bits    | 512 bits     |
| SHA-224     | 224 bits    | 512 bits     |
| SHA-512/224 | 224 bits    | 1024 bits    |
| SHA-256     | 256 bits    | 512 bits     |
| SHA-512/256 | 256 bits    | 1024 bits    |
| SHA-384     | 384 bits    | 1024 bits    |
| SHA-512     | 512 bits    | 1024 bits    |

: overview of hash algorithms

Remember that all SHA algorithms are padded with at least 1 bit + the length field up to a complete
number of blocks.

The length field is 64 bits for 512 bit block sizes and 128 bits for 1024 bit block sizes.
