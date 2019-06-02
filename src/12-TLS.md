# TLS {#sec:TLS}
Is one of the most widely used security protocol of today.

It is the successor of SSL, which is now advised against, and is still being developed - the newest
version, TLS 1.3, was released in 2018. TLS is based on the use of a PKI and is often used to
establish secure sessions with web servers, among other things. The design goal is to secure
reliable end-to-end services over TCP, using TCP (although UDP-variants exist).

Even though TLS 1.3 is released, the most supported version is 1.2.

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
- phases 2 and 3: Key exchange. How this is done depends on the outcome of phase 1.
- phase 4: finalize the setup of the secure connection.

### Phase 1 - "hello" {#sec:TLS:handshake:phase1}
Client and server negotiate TLS version, cipher suite and nonces to be used in compression and key exchange.
This consists of two messages:

First a client "hello" which states the highest version of TLS
available as well as which ciphersuites are available. Also sends client nonce, $N_c$.

Afterwards, the server responds with a "hello" that returns the servers' selection of version and
ciphersuite from the list sent by the client. Also sends server nonce, $N_s$, to client.

### Phase 2 - Server {#sec:TLS:handshake:phase2}
Server sends its certificate (obtained by a CA) to client, as well as its input to the key exchange
algorithm (server key exchange). If the negotiated scheme includes client authorization, request the
clients' certificate.

### Phase 3 - Client {#sec:TLS:handshake:phase3}
Client reponds by sending its input to the key exchange algorithm (client key exchange). If
requested by the server, also send own certificate. Verify server's cert with CAs public key. This
public key is assumed to be available, as its often shipped with your web browser etc.

### Phase 4 - start of communications, summary of handshake {#sec:TLS:handshake:phase4}
Finalizing the handshake, both the server and client switches to the ciphersuite negotiated earlier.
Both also sends a checksum of the previous messages so both can verify it is correct.

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

## Ephemeral Diffie-Hellmann handshake{#sec:TLS:EDH}
This is one of several variants of the TLS handshake protocol.

The server key exchange sends the generator, group parameters and the server ephemeral value
to be used in Diffie-Hellmann. All of these values are signed by the server.

The client key exchange sends the client ephemeral Diffie Hellmann value, which  might be signed
depending on whether client certification is used or not.

Pre-master secret, _pms_, is the shared Diffie-Hellmann secret.


## RSA handshake{#sec:TLS:RSA}
The server key exchange is not a thing in RSA handshake.

The client key exchange sends the pre-master secret, _pms_, by selecting a random value for it
and encrypting it with the server's public key. The server then retrieves _pms_ by decrypting it
using its own private key.

## Other variants{#sec:TLS:other}
(Static) Diffie-Hellmann can be used with certified keys. Should the client not have a cert (which
often is the case browsing the internet), then the client uses an ephemeral Diffie-Hellmann key.

Another variant is the anonymous Diffie-Hellmann. Here the ephemeral keys are not signed, which
means they are only protected against passive eavesdropping.

## Generating session keys{#sec:TLS:sessionkeys}
To generate session keys, a master secret, _ms_, is needed. This is defined using the pre-master
secret, _pms_, as:\
$ms = PRF(pms, \text{"master secret"}, N_c || N_s)$\

All "keying material", _k_, are generated from _ms_ by using:\
$k = PRF(ms, \text{"key expansion"}, N_s || N_c)$

Session keys are partitioned from _k_ in each direction (write key || read key). Depending on
ciphersuite the keying material, _k_, can be an encryption key, a MAC key, an IV etc.

The function `PRF` (pseudorandom function) used above is built from HMAC with a specified hash
function. Older TLS versions (1.0, 1.1) used MD5 and SHA-1, but newer (1.2+) uses SHA-2.

## Alert protocol{#sec:TLS:alert}
The alert protocol is there to allow signals to be sent between peers. These signals are mostly
used to inform the peer about the cause of a protocol failure. Some of these signals are used
internally by the protocol and the application protocol does not have to cope with them, and
others refer to the application protocol solely. An alert signal includes a level indication
which may be either fatal, close_notify or warning (under TLS1.3 all alerts are fatal). Fatal
alerts always terminate the current connection, and prevent future re-negotiations using the
current session ID.

The alert messages are protected by the record protocol, thus the information that is included
does not leak. Improper handling of alert messages can be vulnerable to truncation attacks.

## Attacks on TLS {#sec:TLS:attacks}

TLS 1.3 is the newest and safest version of TLS, which aimed to remove unnecessary/unsafe things and boost
performance while retaining backwards compatibility. Sadly, TLS 1.3 isn't universally supported yet
so unsafe features are still used (like unsafe ciphers).

### BEAST
BEAST (Browser Exploit Against SSL/TLS) exploits non-standard use of IV in CBC mode
(see @sec:blockciphermodes:confidentiality:cbc). This attack allows the attacker to retrieve the plaintext.

No longer considered a threat, as TLS 1.1 only allows random IVs and browsers implement migitation
strategies against it.

### CRIME and BREACH
These attacks target the fact that compression leaks information. CRIME targets optional compression
in TLS and BREACH target compression in HTTP. Mitigated by not using compression, in fact TLS1.3
removed the option to have compression.

### POODLE
A padding oracle is a way for an attacker to know if a message in a ciphertext was correctly
padded. CBC mode encryption may act as a padding oracle due to its error propagation. This can be
applied to attacks on TLS, and is mostly mitigated by having a uniform error response so the
attacker doesn't know what kind of error occurred.

POODLE (Padding Oracle on Downgraded Legacy Encryption) forces downgrade to SSL3.0 (which is
deprecated) during the handshake by stating it as the highest available version and then does
a padding oracle attack.

### Heartbleed
A bug that could be exploited, which is now fixed. Due to some missing boundary checks in the heartbeat
messages that checks if the connection is still active, the server could leak memory that could contain
session- and long-term keys.

### Man-in-the-middle attacks
These attacks reply on issuing a new certificate and installing a root certificate in the browser.
The ad/bloatware/malware company superfish had a scandal in 2015, called the "lenovo incident". Some
lenovo computers were pre-installed with superfish software that included an unsafe, universal
certificate authority signed by itself which would allow superfish to put ads on encrypted websites.

This backfired the hell out of this world and allowed everyone to eavesdrop and tamper with encrypted
traffic from these computers.

## TLS 1.3{#sec:TLS:1.3}
Some changes from TLS 1.2 to 1.3 has been already mentioned. For your viewing pleasure, a more
readable and complete list is presented:

Things removed:

- Static RSA key exchange
- Diffie-Hellmann  key exchange
- session renegotiation
- SSL negotiation
- DSA
- Compression
- non-AEAD ciphersuites (@sec:authencryption:modes)
- MD5 hash
- SHA-224 hash
- change cipher spec protocol
- shittons of ciphersuites and encryption algorithms.
    - TLS 1.2 supported 319 suites
    - TLS 1.3 only allows 5
- PRF
    - TLS 1.3 introduced a new way of deriving keys called HKDF (HMAC-based Key Derivation Function)

Things changed/added:

- Handshake is cleaned up and more efficient
- ONLY AEAD ciphersuites
- added new cipher and mac algorithms
- separate key agreement and authentication algorithms in ciphersuites
- Encrypted messages in handshake
- 0-RTT mode (fast handshake given a pre-shared key, no forward secrecy yet. This is unfortunate)
- backwards compatibility (which adds *a lot* of complexity)

