# Email security {#sec:email}

Even though TLS mostly has our back, Emails still tend to be sent without any security measures.
Despite instant messaging, instagram and god knows what kids do these days, emails still make up for
a big part of all electronic communications.

![Architecture of email. Stallings, "Cryptography and Network Security"](figs/email.png){#fig:email width=65%}

When evaluating security in email systems, we consider the usual confidentiality, authentication
and integrity categories. The availability of the email service itself may also be threatened.

We usually think about security between agents on a link-by-link basis as well as security between
clients on an end-to-end basis. Both have pros and cons, and using both provides the best security.

## Link security{#sec:email:link}
The following two techniques are widely used today by big email services. Gmail stated it was able
to use STARTTLS (@sec:email:link:starttls) on 92% of both incoming and outgoing emails (feb 2019) and DKIM
(@sec:email:link:dkim) on 83% of incoming mails (april 2015).

### DKIM {#sec:email:link:dkim}
The DomainKeys Identified Mail specification allows each domain (gmail, outlook etc) to sign outgoing
mail using RSA. Receiving domains can verify this signature. This helps prevent spoofing, which in
turn reduces spam and phishing scams. The verification key of the sending domain is retrieved using
DNS.

DKIM aims to provide an email authentication scheme that is transparent to the user. The sending
domain automatically signs outgoing email and the receiving domain verifies it. Should the
verification fail, the email is discarded and the user will never see it. The verification will
fail if an email states it is from one place, but in reality it is from another. No part of this scheme
requires user interaction.

Both headers and messages are signed, Unlike S/MIME (see @sec:TODO) where only the message content
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

### STARTTLS{#sec:email:link:starttls}
The astute reader may have noticed the names on the arrows in @fig:email. These are protocols used
to transfer mails between different entities. STARTTLS introduce extensions to these protocols,
STMP, POP, IMAP, to run over TLS connections. This provides non-repudiaton, confidentiality and
integrity for the messages between each link (link-by-link security).

Note that this does not provide end-to-end protection.

STARTTLS only uses TLS when possible, so it is vulnerable to a so-called STRIPTLS attack. This is
where the attacker interrupts the TLS negotiation causing the system to fall back to plaintext
transmission.


