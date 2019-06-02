# Key management {#sec:keys}

Key management includes several aspects:

- Key generation
    - Keys should appear to be random, each key is equally likely to occur
- Key distribution
    - Keys should be distributed to users in a safe manner
- key protection
    - Keys should be accessible when needed, but not to unauthorized users
- key destruction
    - Once a key has done its job, it needs to be destroyed

Keys are usually split into two categories:

1. Long term/static keys
    - Used to protect distribution of session keys
2. Short term/session keys
    - used to protect communications within a session

## Key establishment {#sec:keys:establish}
Symmetric encryption is usually more efficient than asymmetric. This means that most session keys
will be a symmetric key to use with AES etc. Long-term keys can be either symmetric or asymmetric,
depending on how distribution is done. It is normal to use RSA to encrypt a symmetric key and send
it, so the receiver can retrieve the session key using its own private RSA key - thus removing the
need for further RSA communication.

There are three common ways to establish keys between parties:

1. pre distribution
2. online server with symmetric long-term keys
3. asymmetric long-term keys

When evaluating the security of a key distribution protocol we look at the following properties:

- Authentication
    - no masquerading allowed. If you think you share a key with another party, B, it is never the
      case that it is actually shared with the party C
- Confidentiality
    - An attacker is not able to see the session key of the victim

A protocol is broken if an attacker can tell the difference between a session key and a random
string.

We assume all attackers are crypto-experts that can eavesdrop on all messages, alter any message
using available information, re-route any message and obtain any session key used in a previous session.


## Authentication{#sec:keys:authentication}
If both parties of the key establishment achieve authentication, we say the protocol provides mutual
authentication.

If only one party achieves authentication, it is called unilateral authentication. This is often the
case in real life applications, where only the server authenticates itself to the client. Client
authentication often happens later, if need be.

## Key pre-distribution {#sec:keys:predist}
A trusted authority (TA) generates and distributes keys to all users when they join the system.
Various schemes exist from generating a key for very user pair, to probabilistic schemes that
guarantee a high probability that you'll have the keys you need. The TA only operates in the
pre-distribution phase, and can go to sleep afterwards.

Generally this scales very poorly.


## Key distribution using asymmetric cryptography {#sec:keys:asymmetric}
This method requires no online trusted authority, but uses public keys for authentication. A PKI
is usually required to manage the public keys. The users generate their own session keys. We look at
two methods, which is both offered within TLS:

### Key transport {#sec:keys:asymmetric:transport}
One user chooses key material and sends it encrypted for the other party. May also be signed by the
sender. This does not provide forward secrecy.

### Key agreement {#sec:keys:asymmetric:agreement}
Both parties provide input for the keying material generation. It is common to provide
authentication by signing messages here. Diffie-Hellman is an example of a commonly used key
agreement protocol.

## Session key distribution with online server {#sec:keys:server}
These methods rely on an online TA that holds keys for every user.
There iscomplete faith in the server, and the security of the whole system depends on it.
It breaks if the server goes down, or if the server itself is malicious/attacked.
Scalability might also become a problem.

An example of such a method:
A server has long-term shared keys with each user, allowing each user to securely communicate with
it. In order to obtain a session key from parties A to B, the following steps are completed:

0. A and B are already in the system, meaning the server has a long term key for both parties, $K_A$
   and $K_B$.
1. A sends a request to the server for a session key with B. This request includes info to identify
   A and B, as well as a unique nonce. The nonce is used for security checking
2. The server responds with a message encrypted with $K_A$. It contains a session key that works
   between A and B, as well as the original request, including nonce, to enable A to verify the
   request was not altered. It also contains the session key and the identifier of A, encrypted with
   $K_B$, so only B can read it.
3. A needs to send the last part of the message to B, since only B can decrypt it.

After B decrypts the received message, both parties have received the symmetric key in a secure manner.
Two more steps are often also desired, as they add authentication.

4. Using the new session key, B sends A a unique nonce.
5. A replies with the result of a transformation on the received nonce (adding one for example)

This protocol is called the `Needham-Schroeder protocol`

## Forward secrecy{#sec:keys:forwardsecrecy}
Forward secrecy is a property that describes whether leaking a long-term key fucks you up or not. If
a leaked long term key (used for key generation) compromises session keys made before the long-term
key was lost, you do not have forward secrecy. If only future session keys, made after the long-term
key was leaked, are compromised then you have forward secrecy.

RSA-based handshakes in TLS does not provide forward secrecy.

Signed Diffie-Hellman handshakes and ciphersuites in TLS does provide forward secrecy. This is
because the long-term keys are only used for authentication.

## Authenticated Diffie-Hellman {#sec:keys:authDH}
The authenticated Diffie-Hellman is a small addition to the basic protocol described in @sec:diffiehellman:protocol. We assume all parties know the verification keys of the other parties.

After Bob has received $g^a$ and is going to reply with $g^b$, Bob adds a signature of $B || A || g^b
|| g^a$ to the reply. When Alice receives this, she verifies the signature received. If it is valid,
she computes the key in the normal fashion. If not, the protocol is aborted.

After computing the key, Alice signs $B || A || g^a || g^b$ and sends it to Bob. Now Bob verifies
the signature and calculates the key if it is valid, and aborts otherwise.

This provides forward secrecy because the long-term keys are only used for authentication.

## Fixing the Needham-Schroeder protocol {#sec:keys:fixing}
@sec:keys:server described the `Needham-Schroeder protocol`, which is widely used and is used as the
basis of other protocols. It does, however, have an unfortunate vulnerability to replay attacks,
where the attacker is able to replay old messages to make the honest party accept an old session
key.





