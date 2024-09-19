# Computational, Authenticated Key Distribution

Encryption, the old-fashioned way

## Abstract

I am the main researcher behind Rosenpass, the only actively-used post-quantum secure protocol with authentication. Rosenpass can be used together with WireGuard and QKD to create hybrid setups, but this is not what I will focus on in this talk. Instead, as the cryptographer of the group, I will attempt to explain the goals and constraints of such a system from a cryptographic perspective.

Together, we will try to get an overview over the many disciplines involved in the construction of real-world cryptographic systems and discuss how these disciplines continuously collaborate to secure systems step by step. We will explore the yardsticks by which high-quality encryption systems are measured and contrast the security properties provided by computational encryption systems any by QKD.

I can not hide the fact that, to many cryptographers, QKD is an inferior technology and for good reason. This however should not discourage proponents of the technology. The need for hybrid systems is an established fact and so we will discuss which properties can only be provided by computational encryption and how extra-security can be achieved even before information-theoretic security becomes practical.

## Value statement

- Computational cryptography secures communication using modest computational resources
- It is deployed on a vast share of the worlds computational resources
- From a practical standpoint, computational cryptography is superior to QKD in all use cases without exception
- There are some features, computational cryptography can only provide by incorporating QKD

Handshake graphic

- Introduce the methods used in cryptography
- Identify the value statement QKD can provide given the above constraints
- Contrast QKD and computational cryptography

## About me

My picture

- Karolin Varner
- Spent a decade as a Software Engineer in industry working for Startups and Corporate Behemoths
- Started a cryptography research project in 2021
- Researcher Engineer at Max Planck Institute for Security and Privacy
- Research interests: Key exchange protocols, computer-aided proofs of security, decryption despite error
- Main founder of Rosenpass e.V.; founded to support interdisciplinary work

## Rosenpass

… Rosenpass slide

- Interdisciplinary

## Cryptography Science Workflow

:::info

@mullana

This might be to complex as it is here in writing.
I can create a template graphic for you.

Swirls

- Identify goals colloquially "Secure communication"
- Operationalize goals "Authenticity, Secrecy"
  (Philosophical)

- Formalize security notions "IND-CCA2, forward secrecy"
- Compare contrast and compose "eCK-PFS-PSK"
  (Mathematical)

- Develop mathematical construction (e.g. Noise-IK)
- Create security proof
  (Mathematical)

- Implement concrete protocol (e.g. WireGuard)
- Optimize concrete protocol
- Find & Attack implementation flaws
  (Computer science)

- Analyze practical security concerns (e.g. side-channel attacks)
- Analyze usability of implementation
  (Computer science, Electrical Engineering, Physics, etc.)

- Disseminate
- Deploy
- Analyze practical security aspects
- Improve usability
  (Operations, Psychology, Social sciences, Human interface design)

- Analyze social impact
  (Social sciences)

Lots of circles in one bigger circle spiraling out.
Each subcirle has an arrow going out "novel attacks"

:::

## Math proofs are fundamental to cryptography

Reduction to mathematical problem:

1. Assume attacker (stateful function) against cryptographic system
2. Construct algorithm that solves mathematical problem using assumed attacker

Information theoretic.

1. Formulate cryptosystems as a function where

   - K – key material – represents any secret information held by all parties
   - D – protected information – represents any information to be protected
   - C – leaked information – represents any information known to the attacker after execution of the cryptosystem

   $F : K \times D \to C$

2. Show that every every possible value of the leaked information, every possible protected information is equally likely

   $\forall c : C, d_1 : D, d_2 : D; |{ k \in K | F(k, d_1) = c }| = |{ k \in K | F(k, d_1) = c }|$

Functional correctness of implementations:

1. Using formal methods from computer science to show that a cryptographic implementation is equivalent to its specification

Implementation security:

1. Using mechanized verification to show that an implementation fulfills security properties such as
   - Timing side-channel resistance (certain assembly operations are forbidden)
   - Memory-safety (utilize advanced programming languages such as Rust to avoid buffer overflow and other memory safety errors)

Efficiency of implementation:

2. Using complexity analysis to show that an implementation's resource usage is efficient-enough

## Practical Security essential in cryptography

- Protection against timing side-channels
- Power side-channels
- Hardware bugs such as Rowhammer, Meltdown or Spectre are analyzed
- User error through analysis of how cryptography is used (usable security)

- => Its odd when QKD considers itself to be outside of cryptography; the field is quite comprehensive

## Open-source & Open-Science: Secure cryptography as a community process

1. Cryptography is ultimately about creating trust
2. Efficient, incremental peer review of implementations is essential
3. Review of cryptographic proofs is essential
4. Its not enough to say "I made this, this is secure"

:::info

@mullana Comic strip style illustration of cryptography as a community process

Panel:

- Single person saying: "Trust me, I built this, this is secure"
- Other person saying: "Can I see it"; single person: "No, its a secret!"; "but what if you made a mistake"
- Single person saying: "Just trust me already!"
- (Narration: Its not enough for a single person to just build something)

GAP

- Cryptographer saying: "Don't trust me, please review my code. I might have made a mistake."
- Big choir of cryptographers saying, single cryptographer: "Lets build it together to catch all our mistakes"
- (Narration: All cryptographers make mistakes. The best ones are those who trust their work the least and who work together to build better code)

:::

## CAKD: Computational, Authenticated Key Distribution

graphic representing TLS.

Usually called a "key exchange".

- Cheap
- Fast
- Secure
- Extremely well analyzed

## Key exchange – Security against quantum computers

Graphic representing Rosenpass.

- Most contemporary cryptography is not secure against quantum attacks
- Migration is possible, Rosenpass is an example
- Modest increase in resource usage

## Security properties: Active vs passive

:::info

@mullana Two strip-style graphics to represent passive and active security.

Passive – eavesdropping: Graphic of alice and bob communicating; attacker trying to listen in

Active – man in the middle: Graphic of alice communicating with attacker; attacker communicating with bob

:::

## Security properties: Secrecy & Authenticity

:::info

@mullana Two strip-style graphics

Secrecy: Panel of attacker trying to pry into a delivery package.

Authenticity: Panel of attacker glueing a patch over the package address, but package contains a certificate when bob takes it out.

:::

## Security properties: Identity hiding, deniability

:::info

@mullana Three strip-style graphics

Identity hiding: Panels of klandestine package-dropoff, delivery. Panel of empty address field. Panel of secret service delivery man being asked who is communicating: "I could tell you but I would have to kill you".

Deniability: Panel of Bob going to a judge: "Alice sent me this". Panel of judge looking at package (with a spyglass?) "I can see no fingerprings. Guess you can't prove it".

Non-repudiation: Panel of Bob going to a judge: "Alice sent me this". Panel of judge looking at a certificate: "This is clearly Alice's seal!"

:::

## Security properties: Forward secrecy

:::info

@mullana Three strip-style graphics

Forward secrecy: Panel of package being received; panel of it being destroyed; panel of burglers not finding the package

Forward secrecy provides no security against active attacks: Panel of burglars stealing the package during delivery.

Forward secrecy can be broken when a cryptographic scheme itself is broken: Picture of burglars analyzing the remains of the destroyed package in a lab.

:::

## Everlasting secrecy: QKD improves on forward secrecy

:::info

@mullana One strip style illustration; one comic-style scientific illustration.

Everlasting secrecy: Picture of destroying the package using some quantum device. Picture of attacker dissapointed at the remains being quantum. "Damn, these are quantum ashes."

Comic style scientific illustration:
A computer network of machines (feel free to represent as dots or circles),
alice & bob communicating through multiple nodes on that network.
The path through that network is marked one color; annotated "Software encryption".
The path through that network is also marked in another color, but this path is interrupted at each node. Labeled "QKD".
One of the nodes contains a graphic representing the attacker.

Subtitle: Software encryption is end-to-end, but QKD is not. What if an attacker manages to take over a node.

:::

- We can not get end-to-end everlasting secrecy, so the forward secrecy that software provides probably still does more for practical security.

## Limitations of QKD

- Usually not open-source
- Usually not open-hardware
- Usually not peer-reviewed
- Expensive
- Inefficient

| Security property   | QKD             | Software encryption |
| ------------------- | --------------- | ------------------- |
| Post-Quantum        | check Green     | Possibly Green      |
| Attacker-mode       | passive RED     | Active Green        |
| Forward-secrecy     | Pairwise Yellow | Green               |
| Everlasting-Secrecy | Pairwise Yellow | No Red              |
| Authenticity        | cross Red       | check Green         |
| Deniability         | cross Red       | check Green         |
| Non-repudiation     | cross Red       | check Green         |
| Identity hiding     | cross Red       | check Green         |

## QKD as a measure of hardware security

:::info

@mullana Once comic-strip style illustration

Strip: Physical data cable connecting alice and bob across multiple nodes (computers).
The entire cable and all nodes are protected by a wall and some guards. At some point the wall ends;
instead each node – computer – now connects to an adjacent QKD device. The now QKD-protected cable (maybe with a glow
in the previous qkd color) now exits the wall and enters another wall where it is terminated by a qkd device.
Panel with engineer: "We managed to cut some costs by switching to QKD devices instead of guarding the entire length of the cable".

:::

## Hybrid QKD & Cryptography

:::info

@mullana Once comic-strip style illustration

Graphic/strip: The aforementioned cable being attacked by burglars; they overwhelm the guards and hack the devices.
Panel with engineer: "Our cable was attacked! Good thing we also used cryptography to protect the data."

:::

| Security property   | QKD                             | Software encryption | Hybrid          |
| ------------------- | ------------------------------- | ------------------- | --------------- |
| Post-Quantum        | check Green                     | Supported Green     | Supposed Green  |
| Attacker-mode       | passive RED                     | Active Green        | Active Green    |
| Forward-secrecy     | Pairwise Yellow                 | Green               | check green     |
| Everlasting-Secrecy | Pairwise, Extremely Slow Yellow | No Red              | Pairwise Yellow |
| Authenticity        | cross Red                       | check Green         | check green     |
| Deniability         | cross Red                       | check Green         | check green     |
| Non-repudiation     | cross Red                       | check Green         | check Green     |
| Identity hiding     | cross Red                       | check Green         | check Green     |

- Expensive
- Inefficient
- Even if QKD devices are not well-reviewed, no security is lost by using them.

## Three pillars in redundant encryption with QKD

- Think of security as redundant, not as additive

- Classical Security
- PQC
- QKD

=== Symmetric Encryption ===

- Tie-in reduction proofs/math problems
