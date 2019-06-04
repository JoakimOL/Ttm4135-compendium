# Comparisons and summaries

| symmetric key length | RSA key length | Elliptic curve key length  |
| -------------------- | ------------   | -------------------------- |
| 80 bits              | 1024 bits      | 160                        |
| 128 bits             | 3072 bits      | 256                        |
| 192 bits             | 7680 bits      | 384                        |
| 256 bits             | 15360 bits     | 512                        |

: different key lengths in different schemes with same security rating


|                | AES                 | DES              | RSA           | Elgamal      |
| -------------- | ------------------- | -----------      | ----------    | ------------ |
| key length     | 128,192,256 bits    | 56 bits          | $n + \phi(n)$ | $2p + g$    |
| block length   | 128 bits            | 64 bits          |               |              |
| output length  | depends on mode*    | depends on mode* | n             | 2*p          |

: comparison of encryption schemes

Smallest acceptable key length to prevent exhaustive key search = 256 bits

if mode uses padding scheme: output is a multiple of block length. If not, it is equal to
plaintext length

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
