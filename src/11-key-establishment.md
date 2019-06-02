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
2. asymmetric long-term keys
3. online server with symmetric long-term keys

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

## Session key distribution with online server/Needham-Schroeder {#sec:keys:server}
These methods rely on an online TA that holds keys for every user.
There is complete faith in the server, and the security of the whole system depends on it.
It breaks if the server goes down, or if the server itself is malicious/attacked.
Scalability might also become a problem.

An example of such a method:
A server has long-term shared keys with each user, allowing each user to securely communicate with
it. In order to obtain a session key from parties A to B, the following steps are completed:

0. A and B are already in the system, meaning the server has a long term key for both parties, $K_A$
   and $K_B$.
1. A sends a request to the server for a session key with B. This request includes info to identify
   A and B, as well as a unique nonce, $N_A$. The nonce is used for security checking later.
2. The server responds with a message encrypted with $K_A$. It contains a session key that works
   between A and B, as well as the original request, including $N_A$, to enable A to verify the
   request was not altered. It also contains the session key and the identifier of A, encrypted with
   $K_B$, so only B can read it.
3. A needs to send the last part of the message to B, since only B can decrypt it.

After B decrypts the received message, both parties have received the symmetric key in a secure manner.
Two more steps are often also desired, as they add authentication.

4. Using the new session key, B sends A a unique nonce.
5. A replies with the result of a transformation on the received nonce (adding one for example)

This protocol is called the `Needham-Schroeder protocol`

### Fixing the Needham-Schroeder protocol {#sec:keys:server:fixing}
Needham-Schroeder has an unfortunate vulnerability to replay attacks, where the attacker
is able to replay old messages to make the honest party accept an old session key.

Assuming the attacker gets hold of an old session key sent from the server and nonce in stage 2, it can
masquerade as party A to persuade B to use the old key. Unless B keeps track of used nonces, it
shouldn't notice a thing.

To defend against this, we need keys to be "fresh" (new) for each session. There are three main
ways of accomplishing this:

1. nonces / "random challenges"
2. timestamps
3. counters

Fixing the problem using nonces requires B to send A a nonce,  $N_B$, which A includes in its
initial request to the server. The server replies in the normal way, including the nonces, key and a
part that is meant for B, encrypted using the public key of B.
Finally, A sends the part of the reply meant for B to B. B can then verify the nonce it started the
protocol with.

similar fixes can be done using timestamps and counters, as it is easy to check whether these are
old or not.

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

## Kerberos {#sec:keys:kerberos}
Kerberos aims to provide secure network authentication in an insecure network environment. It
features a single-sign on solution to selectively provide services using individual tickets. It
establishes session keys to deliver confidentiality and integrity.

Kerberos is divided into three levels:

### Level 1 - authentication server {#sec:keys:kerberos:level1}
> A client, _C_, interacts with the authentication server, _AS_ in order to obtain a ticket-granting ticket.
> This happens once for a session.

The client sends identifying information about itself and the ticket-granting server (_TGS_) it wishes to
communicate with, as well as a nonce.

Request = $ID_C, ID_{TGS}, N_1$, where $ID_C$ and $ID_{TGS}$ is the identity of the client and TGS,
respectively.

The authentication server replies with a symmetric key $K_{C, TGS}$, as well as the original message,
encrypted with the public key of C, similar to Needham-Schroeder.
The nonce is used to check that the key is fresh, like in Needham-Schroeder. A ticket is also received
in this stage.

Response = $\{K_{C, TGS}, ID_{TGS}, N_1\}_{K_{C}}, ticket_{TGS}$

Tickets allow clients to access a server within a validity period, and contain information about the
client, the symmetric key to use and the validity period.

$ticket_{tgs} = \{K_{C, TGS}, ID_C, T_1\}_{K_{tgs}}$, where $K_{tgs}$ is a long term key shared
between AS and TGS and $T1$ is a validity period

The ticket, $ticket_{tgs}$, is used to obtain different service-granting tickets from the
ticket-granting server.

### Level 2 - ticket-granting server {#sec:keys:kerberos:level2}
> The client, _C_, interacts with the ticket-granting server, _TGS_, in order to obtain a service ticket. This
> happens once for each server during the session.

Pretty much the same thing, except we identify an application server, _V_, instead of a _TGS_.
Initial request sends the identity of _V_, $ID_V$, a new nonce, $N_2$, the ticket from the
previous level and a so-called authenticator.

The authenticator includes your identity as well as a timestamp, encrypted with the symmetric key
$K_{C,TGS}$. The queried _TGS_ checks that this timestamp is recent, and that your identity is authorized
to access the requested service.

$Authenticator_{TGS}$ = $\{ID_C, TS_1\}_{K_{C,TGS}}$

Request = $ID_V, N_2, ticket_{tgs}, authenticator_{tgs}$

If the checks performed by _TGS_ show a green light, a normal Needham-Schroeder-esque response is
received: A key to communicate with _V_, $K_{C,V}$ and the original request, encrypted using the
symmetric key obtained from the previous level, $K_{C, TGS}$, and a new ticket for _V_.

Response = $ID_C, ticket_V, \{K_{C,V},N_2,ID_V\}_{K_{C,TGS}}$

The ticket, $ticket_{v}$, is used to access a specific server _V_.

### Level 3 - application server {#sec:keys:kerberos:level3}
> The client, _C_, interacts with the application server, _V_, in order to obtain a service. This happens
> once for each time the client requires service during a session.

We already have access to _V_ after level 2. We send our ticket, $ticket_V$, and a new authenticator
with a new timestamp to the server.

$Authenticator_V$ = $\{ID_C, TS_2\}_{K_{C,V}}$

Request = $ticket_V, authenticator_V$

In response the server sends back the timestamp encrypted using the symmetric key from
the previous level. This reply intends to provide mutual authentication so the client,
_C_, can check it is using the right service, _V_.

Response = $\{TS_2\}_{K_{C,V}}$

### Limitations {#sec:keys:Kerberos:limitations}
Kerberos does support different "realms", this means having multiple authentication servers that run
provide different services. Despite this, scalability is an issue. Because of this kerberos is best
suited for corporate environments with shared trust.

It is possible to guess passwords when the client key, $K_C$, is derived from a human memorable
password.

The Kerberos standard does not specify how to use the session keys/tickets after their
establishment. This allows for unsecure implementations.
