# TLS {#sec:TLS}
Is one of the most widely used security protocol of today.

It is the successor of SSL, which is now advised against, and is still being developed - the newest
version, TLS 1.3, was released in 2018. TLS is based on the use of a PKI and is often used to
establish secure sessions with web servers, among other things. The design goal is to secure
reliable end-to-end services over TCP (although UDP-variants exist).

TLS consists of three higher level protocols:

1. TLS Handshake protocol to set up secure sessions
2. TLS alert protocol to signal events such as failures
3. TLS change cipher spec protocol to change the cryptographic algorithms in use

As well as the TLS record protocol which provides basic services to the higher level protocols.

## Record protocol {#sec:TLS:record}
The record protocol aims to provide two services for TLS connections, that we have discussed earlier
in the course:

1. Message confidentiality:
    - message contents cannot be read in transit
2. message integrity:
    - detect tampering with messages

These services are provided by a symmetric encryption scheme and a MAC. Later TLS-versions (1.2+)
also offer these services by using authenticated encryption modes (CCM and GCM, see @sec:authencryption:modes).
Necessary keys are set up by the handshake protocol.

The record protocol format contains a header describing the type and length of the content, as well
as a specification of which TLS version in use. Legal types include:

- change-cipher-spec
- alert
- handshake
- application-data

After the header comes an encrypted part containing the message, optionally
compressed (compression removed in version 1.3, due to CRIME 2012 attack), and a MAC field in case authenticated encryption is not used.

The record protocol splits each application layer message in blocks of $2^{14}$ bytes or less.

### Cryptographic algorithms in TLS {#sec:TLS:record:algorithms}

MAC:

The HMAC scheme is used to provide integrity in TLS, with an agreed-upon hash functions
    - SHA2 is only allowed in TLS 1.2+
    - MD5 and SHA-1 not allowed in TLS 1.3

Encryption:

An agreed-upon block cipher in CBC-mode or stream cipher is used. Most commonly AES.

    - RC4 and 3DES is supported in TLS 1.2
    - Both removed from TLS 1.3 (in order to avoid a handful of attacks)

Authenticated encryption:

Using authenticated encryption is also allowed from TLS 1.2, replacing the MAC and encryption algorithm.
In TLS 1.3, the only allowed configuration is AES in CCM or GCM modes. Authenticated additional data
is the header and implicit record sequence number.

## Handshake protocol {#sec:TLS:handshake}
All above mentioned "agreed-upon" algorithms, as well as which version of TLS to use, is decided in
the handshake. The handshake also establishes a shared session key to use in the record protocol,
authenticates the server and finally completes session establishment. Some times it also
authenticates the client, but it is not always required.

There are several variants:

- RSA
- Diffie-Hellmann
- pre-shared key
- mutual authentication or server-only authentication

TLS 1.3 simplifies this process (whew!).

The handshake is split into four phases:

- phase 1: initiate the connection and establish security capabilities (determine algorithms, versions etc)
- phases 2 and 2: Key exchange. How this is done depends on the outcome of phase 1.
- phase 4: finalize the setup of the secure connection.

### Phase 1 - "hello" {#sec:TLS:handshake:phase1}
Client and server negotiate TLS version, cipher suite and nonces to be used in compression and key exchange.
This consists of two messages:

First a client "hello" which states the highest version of TLS
available as well as which ciphersuites are available. Also sends client nonce, $N_c$.

Afterwards, the server responds with a "hello" that returns the servers' selection of version and
ciphersuite from the list sent by the client. Also sends server nonce, $N_c$, to client.

### Phase 2 - Server {#sec:TLS:handshake:phase2}
Server sends its certificate (obtained by a CA) to client, as well as its input to the key exchange
algorithm (server key exchange). If the negotiated scheme includes client authorization, request the
clients' certificate.

> TODO
### Phase 3 - Client {#sec:TLS:handshake:phase3}

> TODO
### Phase 4 - start of communications, summary of handshake {#sec:TLS:handshake:phase4}

### TLS Ciphersuites {#sec:TLS:handshake:ciphersuites}
TLS ciphersuites specify which algorithms to use, both for key establishment as well as the later
authenticated encryption and key generation. There are a literal fuck ton of suites to choose from,
and many are bad. TLS 1.3 have removed a bunch, and requires all ciphersuites to be `AEAD`  (see
@sec:authencryption:modes)

An example of a ciphersuite is TLS_RSA_WITH_3DES_EDE_CBC_SHA. This unholy abomination means:

- The key exchange will use RSA for encryption
- 3DES in CBC mode will be used for encryption of secure communications
- SHA-1 will be used in HMAC


The first part denotes the handshake algorithm, the second part denotes (authenticated)encryption
scheme and the third part denotes the means of achieving integrity (key deriving or hash function) ?


