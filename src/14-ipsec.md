# IPsec {#sec:ipsec}

> Internet protocol security (IPsec) is a framework for ensuring secure communications over IP
networks

It provides similar features as TLS, but at a lower layer in the protocol stack, meaning it adds
protection for any higher level protocol like TCP and UDP.

Compatible with both IPv4 and IPv6.

IPsec offers the following security services:

- Message confidentiality
    - by encryption
- Message integrity
    - by MAC
- Traffic analysis protection
    - hard for someone monitoring the network to determine who is communicating with whom, how
    often and how much data.
    - By concealing IP datagram details
- Message replay protection
    - Same data is not delivered multiple times, and data is not delivered badly out of order
- Peer authentication
    - Each IPsec endpoint confirms the identity of another endpoint it wants to communicate with
    - ensures that network traffic is sent from the expected source

As an added bonus, IPsec is transparent to both applications and end-users, so you don't need to
alter any software on an end-users computer when IPsec is implemented in the firewall or router. The
end-user doesn't have to do anything differently.

## Gateway-to-gateway architecture {#sec:ipsec:gatewaygateway}
This architecture provides secure communications between two networks. The traffic is routed through
an IPsec connection (firewall, router etc) which protects it. This only protects the data between
the two gateways, so it is often used to connect two already secured networks over the internet.
This can be less costly than private WAN circuits.

## Host-to-gateway architecture {#sec:ipsec:hostgateway}
This architecture is used to provide secure remote access. The organization deploys a VPN gateway on
their network, which each remote access user can establish a VPN connection to. This is useful to
connect hosts on unsecure networks to the resources of a secured network.

## Host-to-host architecture {#sec:ipsec:hosthost}
This architecture is used for special needs, such as remote management of a single host. Only this
architecture provides protection for data throughout its transit (end-to-end). This is a costly
architecture to implement and maintain, as it requires sometimes manual management of every host,
user and key.

## Protocols{#sec:ipsec:protocol}
`Authentication Header` (AH) provides authentication, integrity and replay
protection. It is deprecated and should not be used. Our focus will be on `ESP` instead.

`Encapsulating Security Payload` (ESP) provides the same as AH with the addition of confidentality.
Which services ESP offers depends on how the security association is set up as well as the location
in the network topology.

An IPSec connection uses either AH or ESP.

`Internet Key Exchange` (IKE) negotiates, creates and manages session keys in security associations.

A security association is a one-way connection between a sender and a receiver that supports
security services on the traffic carried on it. It contains info needed by an IPsec endpoint
to support the IPsec connection.  This info can include things like keys, algorithms, expiration
dates for keys, security protocol identifier (AH or ESP) and a `security parameter index` (SPI). The
SPI is used to associate a packet with the appropriate security association. As stated above,
Security associations are unidirectional, which means you need one for incoming and outgoing
traffic for every connection.

## Modes {#sec:ipsec:modes}
Both AH and ESP support two modes: `transport mode` and `tunnel mode`. We will only consider the ESP
variants for each, because AH is dumb.

Transport mode preserves the original IP header of the packet and protects the payload. It protects
the data by padding the data with the ESP trailer. After padding, the SA can encrypt the data and
trailer. An ESP header containing the SPI is added in front of the encrypted data. If the SA uses
authentication, a MAC will be calculated and added to the back. This block is called the ESP Auth,
since it is used to verify the authenticated blocks (ESP header, trailer and data). Finally, the
original IP header needs some slight modifications:

- change protocol field from TCP to ESP
- Length field must be recalculated to reflect the added ESP blocks
- checksums must be recalculated

This is mostly used in host-to-host architectures.

Tunnel mode encapsulates the entire original IP packet (header AND data), instead of just the data.
Except for this, it is very similar to transport mode, with the padding, encryption and
optional authentication. Keep in mind that the padding pads both the ip header and data, so both
can be encrypted. The MAC includes the ip header as well. Since the IP header is encrypted
and hidden, we need a new one. A new outer IP header is added, which may contain distinct
addresses such as security gateways (to enter a network, where the inner IP address is valid).
The protocol field is set to ESP. The original IP header is left unmodified

This is mostly use in gateway-to-gateway architectures

In the words of a smart friend:

> tunnel: døtte hele ip pakka inn i en ny ip pakke, ofte brukt med gateway-gateway\
> transport: døtter payloaden av ip pakka, bruker eksisterende ip header

## Attacks {#sec:ipsec:attacks}
Attacks against ESP without authentication exist, which caused the new 2005 version of IPsec to not
require support for encryption-only mode. Still supported for legacy reasons.

ESP encrypts before MAC, but AH MACs before encryption. Attacks against this is known.
