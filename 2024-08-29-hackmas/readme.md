# Section: Prelude

## Title page

% :information_source: Insert default title page

# Section Intro

## Who we are

% :information_source: Use two column layout

% :information_source: Benjamin lipp photo with quick bio

% :information_source: Karolin Varner with bio:

- Worked in industry since 2012 as a software engineer; highlights
    - 2013-2014: Soup io, keeping a dieing social network alive on my own
    - 2015-2017: Softwear BV, migrating legacy databases from the 80es to modern infrastructure
        - Mongo DB C++11 driver discovery, full of buffer overflow bugs
    - 2017-2018: Qabel, developing firmware for HSM, implementing Noise based protocols
    - 2019-2023: Adobe (boring)
    - 2024: MPI-SP

## Rosenpass History

% :information_source: Use two column layout

% :information_source: Left column – Rosenpass Sequence Diagram

% :information_source: Right column – Rosenpass Logo with history

- Grew out of follow up orders from clients karolin met at cable (who could not pay)
- Tried to implement Post Quantum WireGuard \[add short citation\]
- Rosenpass released sprint 2023
- Rosenpass e.V. founded early 2023 for governance
- found issues in PQWG led to protocol improvements

## Todays talks

% :warning: TODO

% :information_source: Decoration – Bunny Rose and WireGuard dragon sketch by mullana.

# Rosenpass

## The rosenpass protocol (1)

% :information_source: Use two column layout

% :information_source: Left column – Rosenpass Sequence Diagram

% :information_source: Right column:

- KEM based authenticated key exchange
- Implicit authentication through KEMs
- Integration with WireGuard
- Useful outside of WireGuard
- Stateless  responder to avoid state disruption attacks [we are going to focus on that a bit more later]
- Three packages (plus final confirmation package)
- First package is unauthenticated
- [Point out where security properties are achieved]

## The rosenpass protocol (2)

% :information_source: Rosenpass packages diagram

% :information_source: Voice track

- [First thing we see here is the envelope which wraps the actual meaningful packages]
- [Then we see Init Hello, Resp Hello and Init Conf]
- [Finally down below we see some more packages which are less central to our discussion of how the handshake works]
- [Point out that every handshake packages has a final authentication tag at the end]
- [Point out ephemeral kem exchange]
- [Point out responder authentication]
- [Point out initiator authentication]
- [Point out that initiator authentication ephemeral exchange only really end in InitConf; due to the auth tag]

## The rosenpass protocol (3)

% :information_source: Rosenpass code diagram

% :information_source: Voice track

- [BAsically tokens from the handshake messages are processed in order]
- [When we get a ciphertext, we decapsulate it and mix the shared key into the handshake state]
- [When we get identity information, we mix the identity (public key) into the handshake state]
- [We end every package with the auth tag]

## The rosenpass protocol (4)

% :information_source: Hash state diagram

% :information_source: Voice track

- [Here is another view of the same process]
- [if you follow these three columns on the right, you can basically see the entire flow of the handshake state]#
- [The real handshake state is really just the single chaining key we use; there is some metadata information like session ids and identities, but cryptographic state is really just a single symmetric key that is continously updated]

- [These nice graphics are really complicated]
- [So we are not going to try to explain them here]
- [Check our whitepaper for details; there you can find these graphics]
- [They are deliberately redundant to make it easier to grasp the design principles]

## Hybrid Security with WireGuard

% :information_source: Formosa Retreat page three sketch of wireguard and Rosenpass integration

% :information_source: Effect – Cut of half of graphic. Add second column

- Hybrid security due to integration with WireGuard
- Keys produced by Rosenpass used in WireGuard as psks
- Continuous key renegotiation
    - WHen Rosenpass fails to exchange a key, we randomize the WireGuard PSK
- This negates some of our advancements in terms of state disruption resistance compared to wireGuard
    - We feel it is worth it though

## Rosenpass usability goals

% :information_source: Insert infographic kem value naming scheme (sski/spki/...)
% :information_source: Insert Infographic ID naming scheme (pidi, sidr)

- Focus on being particularly reader frienly
- Our communication targets non cryptographers too
- Somewhat speaking variable names

## Analysis usability – Colorful ProVerif

% :information_source: Insert proverif in technicolor screenshot

% :information_source: Effect – Cut of half of proverif in technicolor picture. Introduce right column:

- Use formal analysis methods
- Make these tools accessible
- Threat formal analysis as a maintained part of the project
- Make it similarly accessible as unit testing/developer focused tools
- We have color!

## Rosenpass security properties

% :information_source: Formosa Retreat slides, slide 2

## Rosenpass security analysis

% :information_source: Insert proverif in technicolor screenshot in the right side. Cut off. Clearly marked as decoration

- Symbolic analysis of Secrecy, Authenticity, and MEX attacks in ProVerif
    - Novel model of different exposure scenarios
    - Essentially listing minimum requirements for security properties to hold
- Symbolic analysis of State Disruption Resistance in ProVerif
    - Modeled using "package accept" and "package rejected" events in the protocol transcript
    - Adversary's inability produce a "package rejected" event for a valid handshake message

# State Disruption

## WireGuard advanced security properties

% :information_source: Insert Rosenpass envelope graphic on the right column

- **Limited Stealth:**
    - Protocol should not respond to packages without some
    - Proof of IP ownership (cookie mechanism) prevents full stealth
    - Attacker needs to know responder key
- **Limited Identity Hiding:**
    - Attacker can not identify initiator identity
    - Attacker can guess responder identity but can not produce a cryptographic proof
        - Reason: Use of responder public key as a pre-authentication step in the protocol envelope
    - Due to role switching both parties can be identified but no cryptographic proof of identity can be generated
- **Limited CPU DOS protection:**
    - Preventing CPU-exhaustion DOS involving network amplification attacks
    - Proof of IP ownership
- **Limited interruption resistance:**
    - Replay protection based on counters
- => These properties are tradeoffs

## State disruption attacks

- Interruption attack
- Prevent successful execution of a cryptographic protocol by inserting messages
- Attacker can observe and insert arbitrarily many messages
- Attacker can not drop or modify legitimate messages
- Denial of Service on the protocol level

## Retransmission protection in WireGuard

% :information_source: Scientific illustration created by Karo

% :information_source: Resize, cutoff or move illustration to the side allowing us to insert text

- In WireGuard the first packet – InitHello – is authenticated
- This allows for replay attacks
- Replay attacks are thwarted by counter
- Initiator has counter based on real time clock (by default)
- => WG requires Real time clock OR stateful initiator
- Responder is semi-statefuf
- Attacker can attempt replay, but this can not interrupt a valid handshake by the initiator

% :information_source: Show full illustration again, explain it

## ChronoTrigger attack

% :information_source: Scientific illustration created by Karo

% :information_source: Resize, cutoff or move illustration to the side allowing us to insert text

- Attacker needs ability to set system time
- Sets system time to future value
- Initiator performs valid handshake
- Attacker records init hello stores it as a Kill Token
- Attacker resets system time on initiator
- Initiation now fails

- Later, even when the attacker looses access to system time, they can still transmit the kill token

- We call this state disruption, because the responder state, the timestamp they store, is disrupted

% :information_source: CLear previous text

- Attacker needs for Initial phase:
    - Eavesdropping access for initiator packets
    - NTP access
- Attacker needs for later phases:
    - No extra access, not even eavesdropping access of any sort
- NTP is not cryptographically protected
- There are mitigations, but these are not perfect
- => Breaking the system time ONCE produces an kill token that lasts forever

## CookieCutter attack

% :information_source: Scientific illustration created by Karo

% :information_source: Resize, cutoff or move illustration to the side allowing us to insert text

- Attacker performs continual DOS attack against responder
- Responder will reply with CookieReply to InitHello asking initiator to provide proof-of-ip-address
- Initiator stores cookie key from CookieReply and waits for their retransmission counter to terminate
    - It waits for their retransmission counter because the alternative could lead to amplification attacks
- Attacker sends faux cookie reply, overwriting the initiator's cookie
- Initiator sends InitHello retransmission, but cookie key is now invalid
- Repeat ad nauseam

% :information_source: CLear previous text

- Attacker needs:
    - Eavesdropping access
    - Knowledge of responder public key
    - Good timing
- Attacker gains:
    - A cheap DOS attack not based on their raw network transmission power

- Attack extends to bidirectional DOS attack
- Attacker needs:
    - Both public keys
    - Eavesdropping access
    - good timing
- Attacker gains:
    - Cheap jamming of any WireGuard handshakes

## WireGuard and Post Quantum WireGuard

% :information_source: Add two graphics comparing WireGuard and PostQuantum WireGuard

% :information_source: Resize illustrations to make room for points

- InitHello is not authenticated; Initiator authentication achieved in InitConf
- PSK moved to InitConf processing
- WireGuard authors reccommend using PSK for InitHello authentication
    - This would work if they did not move PSK processing into InitConf
- No change in cookie processing

# SLIDE: State Disruption of PQ WireGuard

% :information_source: Add state disruption against WG graphic
% :information_source: Move illustration to make room for points

- State Disruption of Post-Quantum WireGuard is simple forgery
- Or replay attack (if public keys are not known)
- ChronoTrigger attack still works (no NTP access needed if public keys are known)

## Post Quantum WireGuard and Rosenpass

% :information_source: Add two graphics comparing PostQuantum WireGuard and Rosenpass

% :information_source: Resize illustrations to make room for points

- Moved PSK into InitHello
- Stateless responder to prevent state disruption
    - State moved into biscuit
- InitHello immediately retransmitted upon CookieReply reception
    - CookieReply must be as big as InitHello to avoid amplification attacks

## ChronoTrigger protocol comparison

% :information_source: Dedicated scientific illustration

% :information_source: Resize illustrations to make room for points

- WireGuard: Affected
- Post-Quantum WireGuard: Worse (public key knowledge is sufficient for kill token generation)
- Rosenpass: Secured by being stateless

# SLIDE: CookieCutter protocol comparison
% :information_source: Dedicated scientific illustration

% :information_source: Resize illustrations to make room for points

- WireGuard: Affected
- Post-Quantum WireGuard: Affected
- Rosenpass: Unaffected by immediate retransmission of InitHello upon CookieReply receipt
    - (CookieReply and InitHello must be of same size)

## Rosenpass advanced security properties

% :information_source: Insert protocol time diagram on left side

- **Limited Stealth:**
    - Protocol should not respond to packages without some pre-authentication
    - Proof of IP ownership (cookie mechanism) prevents full stealth
    - Attacker needs to know responder key
- **Limited Identity Hiding:**
    - Attacker can not identify initiator identity
    - Attacker can guess responder identity but can not produce a cryptographic proof
        - Reason: Use of responder public key as a pre-authentication step in the protocol envelope
    - Due to role switching both parties can be identified but no cryptographic proof of identity can be generated
- **Limited CPU DOS protection:**
    - Preventing CPU-exhaustion DOS involving network amplification attacks
    - Proof of IP ownership
    - **Slightly more exposed due to more expensive cryptographic operations**
- **Full interruption (state disruption) resistance:** Stateless responder
- **Post-Quantum secure!**

- => Rosenpass is as secure as WireGuard but using PostQuantum security
- => Additional state disruption resistance
- => CPU-exhaustion resistance is slightly worse, but that is due to the cost of the cryptographic primitives

## Knock Patterns

% :information_source: Insert dedicated scientific illustration

% :information_source: Resize illustrations to make room for points

- We choose to call proof of ip ownership/CookieReply and preauthentication based on public key knowledge knock patterns
- These knock patterns have severe trade offs.
- Interactive knock patterns (e.g. Proof of ip ownership) break stealth
- Identity based knock patterns (e.g. using knowledge of the responder public key for pre-auth) breaks identity hiding

## Pre-auth trade-off

% :information_source: Insert dedicated scientific illustration

% :information_source: Resize illustrations to make room for points

- Choose two or some trade-off inbetween
    - WireGuard claims to provide identity hiding and stealth by declaring their trade-offs in these areas to be good enough
    - => These trade-offs should be known
- Identity hiding and stealth can be achieved by giving up CPU-Dos prevention
    - We would prefer, if async cryptographic primitives would be fast enough

- => More research needed in finding better CPU DOS mitigations
- => High-quality proofs needed to actually verify security properties of protocols
    - Modeling of these advanced security properties was insufficient in both WireGuard and PQWG

# Section: Better proof tools

## Pen and Paper proofs

- Become increasingly unwieldy
- Karolin anecdote: Recently found major issues in fairly prominent paper, page N
    - (TODO: Handle issues found with Signal analysis)
- Proof state is hard to keep track off

% :information_source: Insert screen-shot of PostQuantum WireGuard paper showing WireGuard proof differential

## ProVerif

% :information_source: Insert screen-shot of our ProVerif analysis

% :information_source: Cut off screen-shot of our code

- No syntax highlighting
- No good tooling to do engineering at scale (karolin resorted to the C preprocessor)

% :information_source: Insert screen-shot of raw ProVerif output on the left; out colorful output on the side.
> Big letters (text below) on white superimposed on split-screen screenshot

ProVerif output is not made for Humans

## CryptoVerif

% :information_source: Insert screen-shot of HPKE or WG analysis by blipp

% :information_source: Cut off screen-shot

TODO: Blipp
- Expert driven engineering

% :information_source: Insert screen-shot of CV documentation saying "to be done"

% :information_source: Cut off screen-shot

- Sometimes the information is simply lacking

## Tamarin

% :information_source: Insert screen-shot of horn clause in text

- When we evaluated Tamarin for use in Rosenpass you had to directly encode horn clauses
- There are new frontends there now
- This is the prover we know least about (looking for input!)

## EasyCrypt

% :information_source: Insert screen-shot of nice EC code

- This appears to be the most complete approach right now
- Writing proofs is hard
- No demonstration of use with protocols at the moment
- Anecdote:
    - When we tried out EC we asked advanced EC researchers at MPI-SP for a tutorial to look at
    - The tutorial contained an unknown syntax
    - We where trying to figure out what this did
    - I went to the very advanced researchers
    - They thanked me for the interruption and started reverse engineering the tool because they did not know either
    - => Engineering problem "naturally-grown" code bases

## Protocol proof approaches

- Pen and paper proofs are hard to vet and error prone
    - Provide a lot of flexibility, this is a good thing
- Formal verification tools work, but they are hard to use.
    - THEY ARE ALSO HARD TO READ EVEN FOR THE AUTHORS
- Option: The basic models may be there
    - They are very strict and formally correct
- We need more ability to hand-wave in formal methods proofs
    - This is supposed to make proofs easier; it is an incremental process
- We need to improve tooling
    - More tooling (syntax highlighting, interactive proof assistants)
    - More user experience (understandable output from proof verifcation tools)
    - More expressiveness

## Protocol proof approaches

% :information_source: Center text, no decorations (i.e. no top bar), big letters.

More expressiveness in formal verification tools

## Oracle declarations in the Rosenpass ProVerif model

% :information_source: Screen shot of one verbose oracle declaration in the Rosenpass symbolic model

% :information_source: Another screenshot 

% :information_source: A screenshotg of a complex C macro in tghe symbolic analysis

% :information_source: A screenshotg of a proverif macro expansion in ProVerif

% :information_source: White text on the right side

- A more powerful language with native support for complex syntax sugar would help a lot
- Syntax rewriting is a basic element of proofs
- It is suprising that our cryptographic proof tools completely lack support for native syntax extensions
- Syntax rewriting is called "macros" when computer-scientists do it
- We have a tool for that; it is called lisp

## Rosenpass going Rube-Goldberg

% :information_source: Architecture diagram of python based proofs

% :information_source: Scale graphic to allow for points

- Embed cryptographic proof syntax in Lisp S-Expressions
- Translate Lisp code to python using the Hy language (lisp that compiles to python)
- Translate S-Expression code to AST or DOM
- Translate AST or DOM to ProVerif/CryptoVerif/EasyCrypt code using the Lark code parser/generator
- Remote control ProVerif/CryptoVerif/EasyCrypt by
    - Parsing their command line output using lark
    - (Possibly using the language server interface for more interactive features)
- Provide custom syntax using
    - Lisp Macros
    - Extending Lark-based syntax parsers (to add custom syntactic elements)
    - AST Rewriting for more complex adaption
- Integrate with external tools by exporting our AST as XML
    - XML is just a convenient grammar for trees
    - We do not need to support the full complexity of XML including XML style sheets and such things

# Section: Epilogue

## Conclusion

% :information_source: Three columns! Add wireGuard Dragon and Bunny Rose sketch for decoration


#### Rosenpass

- Post quantum secure key exchange
- Same security as WireGuard
- Improved state disruption resistance
- Transfers key to WireGuard for hybrid security

#### Protocol finding

- CookieCutter: DOS exploiting WireGuard cookie mechanism
- ChronoTrigger: DOS exploiting insecure system time to attack WireGuard
- There is a trade-off between identity hiding, stealth, and CPU-exhaustion DOS protection

#### Talk to us

- About tamarin
- State disruption attacks
- Stealth and Identity hiding
- Adding syntax rewriting to the tool belt of mechanized verification in cryptography

## 
