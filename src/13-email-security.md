# Email security {#sec:email}

The following sections about email security might be a bit verbose. This is because the lecturer
hinted towards the exam requiring deeper knowledge than the slides provide about these subjects.

Even though TLS mostly has our back, Emails still tend to be sent without any security measures.
Despite instant messaging, instagram and god knows what kids do these days, emails still make up for
a big part of all electronic communications.

![Architecture of email. Stallings, "Cryptography and Network Security"](figs/email.png){#fig:email width=65%}

When evaluating security in email systems, we consider the usual confidentiality, authentication
and integrity categories. The availability of the email service itself may also be threatened.

We usually think about security between agents on a link-by-link basis as well as security between
clients on an end-to-end basis. Both have pros and cons, and using both provides the best security.

# Link security{#sec:link}
The following two techniques are widely used today by big email services. Gmail stated it was able
to use STARTTLS (@sec:link:starttls) on 92% of both incoming and outgoing emails (feb 2019) and DKIM
(@sec:link:dkim) on 83% of incoming mails (april 2015).

## DKIM {#sec:link:dkim}
The DomainKeys Identified Mail specification allows each domain (gmail, outlook etc) to sign outgoing
mail using RSA. Receiving domains can verify this signature. This helps prevent spoofing, which in
turn reduces spam and phishing scams. The verification key of the sending domain is retrieved using
DNS.

DKIM aims to provide an email authentication scheme that is transparent to the user. The sending
domain automatically signs outgoing email and the receiving domain verifies it. Should the
verification fail, the email is discarded and the user will never see it. The verification will
fail if an email states it is from one place, but in reality it is from another. No part of this scheme
requires user interaction.

Both headers and messages are signed, Unlike S/MIME (see @sec:end:smime) where only the message content
is signed. Another difference from S/MIME is that DKIM applies to all mail from domains that use it.
S/MIME depends on whether each user uses it or not (and few people do).

Basic message processing is divided between a signing ADministrative Management Domain (ADMD). A
message is signed by the originating ADMD, and verified at the delivering ADMD. In reality, there
may be more ADMDs in the path between the originating and delivering ADMDs, called relaying ADMDs.

The signing ADMDs signs a message by adding a new header field containing the signature, using
private information from a key store.

The verifying ADMD verifies the signature using public information and if the signature passes, the
signers' reputation information is passed onto the filtering system. If the verification fails, or
the signature is missing, information about how the sender signs is gathered and examined. If a mail
from gmail, that should be signed, is found without a signature, then you can consider it
fraudulent.

## STARTTLS{#sec:link:starttls}
The astute reader may have noticed the names on the arrows in @fig:email. These are protocols used
to transfer mails between different entities. STARTTLS introduce extensions to these protocols,
STMP, POP, IMAP, to run over TLS connections. This provides non-repudiaton, confidentiality and
integrity for the messages between each link (link-by-link security).

Note that this does not provide end-to-end protection.

STARTTLS only uses TLS when possible, so it is vulnerable to a so-called STRIPTLS attack. This is
where the attacker interrupts the TLS negotiation causing the system to fall back to plaintext
transmission.

# End to end security{#sec:end}

## PGP - Pretty good privacy{#sec:end:pgp}
PGP protect the contents of emails. It offers authentication, integrity, non-repudiation and
confidentiality of the message body.

A random session key is generated for each message, and this key is encrypted using
the long-term public key of the recipient (asymmetric encryption). The messages themselves are
encrypted using symmetric encryption using the session key. OpenPGP requires support for Elgamal and
recommends support for RSA encryption as well for the asymmetric algorithm. The symmetric algorithm
requires support for 3DES with three keys (168 bits), but recommends AES-128 and CAST5. Definitions
for other algorithms also exist.

The messages are optionally signed using RSA or DSA signatures, then compressed using zip to a base64
encoding to ensure compatibility. RSA signed messages are hashed using SHA1, which is has required
support by the standard), or SHA2. Compression happens before encryption. Encryption can be applied
independently of signing, i.e. there is no requirement of authenticated encryption.

### "Web of Trust"{#sec:end:weboftrust}
Each user generate their own public/private keys, and distribute the public keys to key servers. Key
servers talk to each other, ensuring that your key will be available to everyone eventually. Any PGP
user can sign another user's public key to indicate their level of trust. Any user can revoke their
own keys by signing a revocation certificate and sending to key server. Key servers then revoke your
key across all servers.

### Usability{#sec:end:usability}
A problem with PGP is the amount of understanding a user should have. Average Joes may not
understand the theory behind PGP and thus use it in an unsafe manner.

Vulnerabilities like EFail use pieces of HTML code to trick users to reveal encrypted messages.

Despite this, the amount of users (or active keys, at least) is rising. PGP is getting easier to use
too, with plugins for popular mail clients being available.

### Criticism{#sec:end:criticism}
The OpenPGP standard still use outdated algorithms like SHA1 and CAST, and does not support newer
and/or safer algorithms like SHA3 and authenticated encryption like GCM.

The message contents are well protected but a lot of metadata is being leaked, such as recipients,
file length and algorithm used.

OpenPGP does not support streaming mode or random access decryption. This means that you have to
wait till you have received the entire message before decrypting. You can also not decrypt part of a
message, you can only decrypt it in its entirety

## S/MIME {#sec:end:smime}
Secure/multipurpose internet mail extensions (S/MIME) offers similar security features to PGP. It
does, however, use a different format for messages, for example by including the sender's public key
with each message (which is used to verify the message).

Another difference is that S/MIME does not use a web of trust, instead it requires X.509 format
certificates (see @sec:PKI:digcert) issued by CAs. Because of this, NIST recommends S/MIME over
PGP, as they are more confident in the CA system. S/MIME is also supported by most popular mail
clients.

### Authentication{#sec:end:smime:authentication}
Authentication is provided through a digital signature, most commonly RSA with SHA-256.

1. The sender creates a message
2. SHA-256 is used to generate a 256-bit hash of the message
3. the hash is encrypted with RSA using senders private key, append result and identifying
   information to the message. (so the receiver can retrieve the signers' public key)
4. The receiver uses RSA with the senders' public key to decrypt the hash.
5. The receiver hashes the received message and checks if it matches the decrypted hash.

Because of the strength of both SHA-256 and RSA, the recipient can be confident that the one with
the matching private key generated the signature and that no one else could generate a message that
matches the hash of it.

The signature is not always appended to the message, as detached signatures are supported. This is
useful in settings where there are several parties that need to sign the same document, as well as
in  security settings where a user wants to keep a separate signature log or even detect virus
infections in executables.

### Confidentiality{#sec:end:smime:confidentiality}
Messages are encrypted, usually with AES in CBC with a 128 bit key. Every symmetric key in S/MIME is
used only once, as a new one is generated for every message. The symmetric key is sent with the
message, encrypted with something safe like RSA.

1. Sender generates message and a random 128 bit number to be used as a symmetric key
2. message is encrypted using symmetric key
3. Symmetric key is encrypted with RSA using recipients public key and attached to message
4. receiver uses RSA with its private key to recover the symmetric key
5. use symmetric key to decrypt message

The choice of using both asymmetric and symmetric encryption is one of performance. Assuming a large
block of content, symmetric decryption is much faster. But symmetric encryption requires key
distribution, which is solved using the random number key that is passed with the message. Since
each message is one-time and independent, we do not require a handshake or session-key exchange,
which strengths the security.

### Confidentiality and Authentication {#sec:end:smime:conf-auth}
Both methods mentioned above can be used on the same message, in any order. Both orders have pros
and cons.

If signing is done first, the identity of the signer is hidden by the encryption. Also,
for third party verification, the third party won't have to bother with the symmetric key encryption when
verifying the signature.

If encryption is done first, it is possible to verify a signature without exposing the message
content. This is useful for automatic verification, as no private keys are needed to verify the
signature.

### Compression{#sec:end:smime:compression}
S/MIME also offers the ability to compress the message, to preserve bandwidth or storage space.
Compression can be done in any order with respect to the signing and encryption operations, as long
as you compress before signing if you use a lossy compression algorithm. It is advised against
compressing binary data, as you'd probably not get much out of it.

### Content types {#sec:end:smime:contenttypes}
S/MIME define four message content types:

1. Data - message
2. SignedData - apply a digital signature to message
3. EnvelopedData - Encrypted content of any kind, as well as necessary keys
4. CompressedData - apply compression to a message

The first type, data, is encapsulated in the others. The other content types feature specific
formats that allow S/MIME compliant systems to handle them, by encapsulating the other types.

It is possible to do something called `clear signing`, which is a procedure that adds safety to
emails, even though the recipient does not implement S/MIME. This is done by signing the data
message, and then sending the message and signature as a multipart MIME(normal email format) message.


