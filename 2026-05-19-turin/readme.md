# 2025-06-03 Tech Meetup Hannover

## Intro

### Wer bin ich?

"Wer bin ich"

- CAST Slide

### Rosenpass e.V.

"Wer ist so in meinem Verein"

- CAST Slide

## Was ist Kryptografie

### Im Prinzip

Absicherung von Kommunikation.

Im Internet, aber auch woanders.

- Private kommunikation – Niemand soll sie mitlesen
    - Küchentisch
    - Briefgeheimnis
    - Arzt
- Schutz vor Kriminalität
    - Bankraub (Online Banking)
    - Betrug
    - Spionage
    - Vandalismus

-> Viel heutzutage im Internet
-> Die Kommunikation muss abgesichert werden

### Was funktioniert Kryptografie

- Zwei computer (oder andere geräte) kommunizieren miteinander
- Haben geheime Schlüssel
- Absicherung von Kommunikation via Mathematik

Grafik: Patient und Arzt Telefonieren

### Experteninfo: Komplexitätstheorie – Exponentialfunktionen

- Parabel vom Reis und vom Schachbrett
    - Sequenz: 
        - 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, ...
        - ..., 2**64 ~= 1e18.9648897268308
    - Rice grain size:
        - https://www.fao.org/4/t0567e/t0567e07.htm
        - Medium, medium: 6mm len, 2.5 len/diameter
            - => 6 mm * 2.4 mm * 2.4mm
        - Grain weight: "1 grain"
            - https://www.quora.com/How-much-does-rice-weigh
    - World Rice production:
        - https://worldpopulationreview.com/country-rankings/rice-production-by-country
        - (208495 + 196246 + 57189 + 54749 + 42672 + 34317 + 24680 + 19756 + 11624 + 10983 + 10776 + 10364 + 8502 + 7274) kt
        - = ~700Mt
    - Chess board:
        - 8x8 squares, 3 cm * 3 cm
    - Rice packing:
        - Approximating Rice corn as a box
        - 5*12 corns is one layer
        - layer height = 2.4 mm
        - Highest field stacks: 2**64 / (5*12) * 2.4mm = 7.37869762948382e14 m = 7.37869762948382e11 km
            - 2466.17735765801 AU (1 AU = 149597870700)
                - Way past pluto
            - (((2**63 / (5*12)) * 2.4e-3) / (9460730472580800))*356 = 13.8827353961161 light days
        - Highest field stack weight is:
            - 2**63 * 0.06479891 * 1e-6 = 5.97664454512669e11 tons
            - (2**63 * 0.06479891 * 1e-3) / 700e9 = 853.806363589528 rice world production
            - ~= 1000 world production
        - Total Rice needed:
            - definite_integral(2**x,x,0,63) = 9223372036854775807/log(2) = 1.33065130978443e19
            - In terms of world rice production:
                - (definite_integral(2**x,x,0,63) * 0.06479891 * 1e-3) / 700e9 = 853.806363589528/log(2) world_prod = 1231.78220663005
- Der Grund warum wirtschaftswachstum nicht ewig geht
    - Menschliche Energienutzung:
        - https://ourworldindata.org/energy-production-consumption
            - Per year: 180 EWh = 648 PJ = 648e18 J
            - Per second: 2.1e13 J = 21 TJ (from year)
        - https://en.wikipedia.org/wiki/Orders_of_magnitude_(energy)
            - Per Year (2010): 5e20J/y = 1.6e13J/s = 16 TJ/s
    - Energy barriers:
        - https://en.wikipedia.org/wiki/Orders_of_magnitude_(energy)
        - Earth solar energy intake: 1.7e17J/s
        - Sun radiative output: 3.828e26 J/s
        - Universe energy content: 3.177e71 J
    - Economic Growth: 
        - Lets say 3.5% – https://de.statista.com/statistik/daten/studie/2112/umfrage/veraenderung-des-bruttoinlandprodukts-im-vergleich-zum-vorjahr/
    - Energy barriers hit:
        - Earth solar intake limit: (1.6e13*1.035**280)/1.7e17 = 1.4 (about year 2300)
        - Solar radiation output: (1.6e13*1.035**900)/3.828e26 (about in 900y)
        - Universe:
            - From approximate mass energy in the universe
            - (Sage): definite_integral(1.6e16*1.035**x,x,0,3605)/3.177e71 = 1.0604429692943143
            - Without integration: (1.6e16*1.035**3705)/3.177e71 = 1.13788599096837
            - I.e. In around 3600y
- Eine Einheit mehr Arbeit für Doktor und patient => Doppelt so viel Arbeit für den Angreifer
    - Landauer limit: 2.9e-21 J
    - Verdopplungsschritte:
        - Earth solar energy intake (year): N(log((1.7e17*3600*24*356)/2.9e-21)/log(2)) = 150.337226574747 (Verdopplungen)
        - Sun solar energy output: N(log((3.828e26*3600*24*356)/2.9e-21)/log(2)) = 181.405635512194 (Verdopplungen)
        - Energieinhalt des Universums: N(log(3.177e71/2.9e-21)/log(2)) = 305 (Verdopplungen)

## Setup

### Gaah die Quantastrophe

"Warum sind wir eigentlich hier"

"Die Zerstörung der Kryptografie"

Reisserische: Youtube Headings

- https://www.youtube.com/watch?v=e-lIgqD5Nxk
- https://www.youtube.com/watch?v=h6w4SX7ZJMQ&pp=ygUXcXVhbnR1bSBjb21wdXRlciBjcnlwdG8%3D
- https://www.youtube.com/watch?v=-UrdExQW0cs&pp=ygUXcXVhbnR1bSBjb21wdXRlciBjcnlwdG8%3D
- https://www.youtube.com/watch?v=05Uy-hFFkRU&pp=ygUXcXVhbnR1bSBjb21wdXRlciBjcnlwdG8%3D
- https://www.youtube.com/watch?v=ON5pVc9bIRo&pp=ygUXcXVhbnR1bSBjb21wdXRlciBjcnlwdG8%3D
    - "Lehrer: Subjekt, prädikat, objekt – Der Satz ist unvollständig"

- Hier geht es viel um Bitcoiin.
    - Wir kryptografen sind ja nicht so glücklich darüber, dass die Bitcoin-Bros uns das Kürzel gestohlen haben

### Shors Algorithmus

- Quantencomputer können ganz bestimmte Kryptografische Algorithmen attackieren ohne exponenziellen Aufwand
- Das geht aber nicht mit allen

"Hey physicists figured out its possible in priciple to build a plane crashing device that works on planes with a 1990 RS McGuffin 25 Engine"
"Its going to be so expensive to change to 1991 RS McGuffin 25 Enginges. Everybody used 1990 ones; they where ten times less expensive"

### Quantum Attack Timeline

"Eins haben quantencomputer mit Fusion gemein"
- "Immer zwanzig jahre weg"

- Alles so ein bisschen schätzungssache

- Expert based poll: https://postquantum.com/post-quantum/q-day-crqc-predictions/
- (Secondary source https://introtoquantum.org/essentials/timelines/)

### Risikobehandlugn

=> Es geht um Risikobehandlung
=> Grafik: Cabriolet stoppt
    - "Rüdiger, hast du vergessen zu tanken"
    - Rüdiger mit Benzinkannister, geht Fuel holen
=> Grafik erde stoppt
    - "Ahh wir haben vergessen die Erde zu tanken"
    - "Hmm, riecht nach huhn" (helle seite)
    - "Yeah, schlitten fahren" (dunkle seite)
    - "Technoparty, die ewige nacht lang" (dunkle seite)

### Store now decrypt later

"Some graphic"

### Fact check:

- Ja, quantencomputer sind eine reele bedrohung

- Weil das Risiko zu hoch ist; Krypto ist einfach zu kritisch

- Weil Store-Now-Decrypt-Later ein Risiko ist

- Kryptografen arbeiten daran (TM)

## Migration hin zu PQ-Sicherheit

### Timeline

- 1978: Erster Post-Quanten-Sichere Primitive Publiziert (Ohne es zu wissen) – McEliece
- 1994: Shors algorithm published – https://en.wikipedia.org/wiki/Shor%27s_algorithm
- 2016: NIST Post-Quantum Primitive Competition Announced – https://csrc.nist.gov/Projects/post-quantum-cryptography/news
- 2019: Cloudflare & Google beging public experiment to deploy PQC on the internet – https://blog.cloudflare.com/towards-post-quantum-cryptography-in-tls/
- 2022: OpenSSH released with post-quantum security support – https://www.openssh.com/txt/release-9.0
- 2023: Rosenpass Released to migrate WG
- 2023: Signal Messenger began migration – https://signal.org/blog/pqxdh/
- 2024: Competition winners selected – https://csrc.nist.gov/News/2024/postquantum-cryptography-fips-approved
- Future:
    - Widespread adoption of PQC
    - You deploy PQC

### The System Challenge

- Sichere Verschlüsselungssysteme bestehen aus vielen Komponenten
- Es müssen sehr viele systeme upgedated werden

Grafik:

- Doktor / Patient kommunizieren
- Dritter Server der Schlüssel verteilt
    - Vierter fünter server
- Pfeil auf patientencomputer:
    - Windows XP, Virusverseucht
- Mensch mit Besen beim Arzt "Haut computer wenn das internet stottert"
- "Heriberts-Kneipe" – Promo USB Stick (Einziger Speicher der Geheimen Schlüssel)
    - Steckt im Zertifikatscomputer

### The incompatibility challenge

- NIST: "Hey we have this shiny new encryption method from the nist competition"
    - Visualize as puzzle piece
- Protocol designer: "It does not work in my system"

-> Outcome one:
    - Sweaty engineer: I made it fit

-> Outcome two:
    - I bolted an extra heisenberg crypto condensator

## Eigenwerbung

### Protocol level combination

- "Rosenpass bolted onto WireGuard via PSK"

### Rosenpass/WireGuard combination Graphic

- (Just take the one that exists)

### The VPN Advantage

- Doktor Grafik von der "System challenge"
- Rosenpass als middlebox
- Bunny Rose sagt: "Hey, I just added it on top"

## Final slide

- OpenSSH – Post Quantum Secure Server Administration

- Signal – Post-Quantum Secure Messaging

- Rosenpass – Post-Quantum Secure (Site to site VPN)

- Mullvan – Post-Quantum Secure Internet Gateway (Internet Gateway VPN)

- WolfSSL – Post-Quantum Capable TLS
    - Chromium
    - Nginx
    - Apache
