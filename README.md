Our goal is to create a common share sheet for Bible apps (starting with iOS). Imaging your reading something in YouVersion and want to get a bit more contextual information, so you open that passage in Logos. Or say you are reading a passage in NeuBible and decide you want to start memorizing it, you can open it in Verses. Or if your memorizing a passage in Verses and want to read it in context you can open it inside the ESV Bible app.

While the foremost goal is to create a link between apps a secondary goal is to create a standard query that each of these schemes accepts. That way websites, etc, will be able to know how to create links that are openable within a Bible app.

Ideally we would use a single urlScheme, something like bible:// but unfortunantly iOS doesnt support this. According to Apple it is "undefined as to which of the applications is picked to handle URLs of that type."

The solution then is to create a share sheet that checks for all of the registered urlSchemes that adhere to the proposed format. If your Bible app wishes to join you must:

1) Submit your specific urlScheme here. The naming convention for this will be "bible-yourappname://"

2) Commit to parsing the incoming data as well as being able to share through the action sheet. Our goal will be to put together some helper classes here for iOS to get things started.

How then will the "common share sheet" function? It will simply go through the list of registered schemes and ask the OS which ones it can open. Only those will be shown by default. You will also have the option to specifically turn on apps which you'd like the user to see as an option regardless of whether they have them or not. If the user does not have them, they will be directed to the app store for download. This then allows certain apps to encourage their users to check out complementary apps.

We will have the default style be system only. Customization will be allowed.

Each listing then will need the follow:

1) The specific urlScheme.
2) An intention, currently there are 3 options: Read, Study, Memorize.
3) A link to the App Store.

Note, that the urlScheme's query will include an "intention" variable at the end. If it is passed into the share sheet with that intention then the share sheet will scope the list to only those options.

The format that we will use to pass information will support the following cases:

• Sharing a single passage (Passage being defined as any number of disjointed references found within a single chapter of a single book)
• Sharing multiple passages
• Sharing a single chapter
• Sharing multiple chapters (Multiple chapters)
• Sharing a single book
• Sharing with one of the three above mentioned intentions (Read, Study, Memorize)
• Sharing with a intended translation (we will have a standardized list for these too)

Example of the format:

bible-yourappname://?passages=[Gen.1.1-Gen.1.4,Gen1.8],[Exo.1.1-Exo.1.8],[Rev.1-Rev.7]&translation=ESV2011&intention=memorize

To share a passage:
[Gen.1.1-Gen.1.4,Gen1.8]

To share multiple passages:
[Gen.1.1-Gen.1.4,Gen1.8],[Exo.1.1-Exo.1.8]

To share a chapter:
[Gen.1]

To share multiple chapters:
[Gen.1-7]

To share a book:
[Gen]


Current apps:

Verses - Status: Integraing, Primary Intention: Memorize, Other Intentions: nil

ESV Bible - Status: Interested, Primary Intention: Read, Other Intentions: Study


Standard list for Books (taken from http://www.crosswire.org/wiki/OSIS_Book_Abbreviations):
Gen 
Exod 
Lev
Num 
Deut 
Josh 
Judg 
Ruth 
1Sam 
2Sam 
1Kgs 
2Kgs 
1Chr 
2Chr 
Ezra 
Neh
Esth
Job
Ps
Prov
Eccl
Song
Isa
Jer
Lam
Ezek
Dan
Hos
Joel
Amos
Obad
Jonah
Mic
Nah
Hab
Zeph
Hag
Zech
Mal
Matt
Mark
Luke
John
Acts
Rom
1Cor
2Cor
Gal
Eph
Phil
Col
1Thess
2Thess
1Tim
2Tim
Titus
Phlm
Heb
Jas
1Pet
2Pet
1John
2John
3John
Jude
Rev

Tob
Jdt
EsthGr
AddEsth
Wis
SirP
Sir
Bar
EpJer
DanGr
AddDan
PrAzar
Sus
Bel
1Macc
2Macc
3Macc
4Macc
PrMan
1Esd
2Esd
AddPs

Odes
PssSol

JoshA
JudgB
TobS
SusTh
DanTh
BelTh

EpLao
5Ezra
4Ezra
6Ezra
PrSol
PrJer

1En
Jub
4Bar
1Meq
2Meq
3Meq
Rep
AddJer
PsJos

EpCorPaul
3Cor
WSir
PrEuth
DormJohn
JosAsen
T12Patr
T12Patr.TAsh
T12Patr.TBenj
T12Patr.TDan
T12Patr.TGad
T12Patr.TIss
T12Patr.TJos
T12Patr.TJud
T12Patr.TLevi
T12Patr.TNaph
T12Patr.TReu
T12Patr.TSim
T12Patr.TZeb

2Bar
EpBar
5ApocSyrPss
JosephusJWvi

1Clem
2Clem
IgnEph
IgnMagn
IgnTrall
IgnRom
IgnPhld
IgnSmyrn
IgnPol
PolPhil
MartPol
Did
Barn
Herm
Herm.Mand
Herm.Sim
Herm.Vis
Diogn
AposCreed
PapFrag
RelElders
QuadFrag
TatDiat
PsMet

Standard list for Translations:

To be added.