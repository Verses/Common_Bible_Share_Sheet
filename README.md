# Purpose
Our goal is to create a common share sheet for Bible apps (starting with iOS). Imagine your reading a passage in YouVersion and want to get a bit more contextual information: so you open that passage in Logos. Or say you are reading a passage in NeuBible and decide you want to start memorizing it: you can open it in Verses. Or if you are memorizing a passage in Verses and want to read it in context: you can open it inside the ESV Bible app.

## Goals
While the foremost goal is to create a link between apps a secondary goal is to create a standard query that each of these schemes accepts. That way websites, etc, will be able to know how to create links that are openable within a Bible app.

Ideally we would use a single urlScheme, something like bible:// but unfortunantly iOS doesnt support this. According to Apple it is "undefined as to which of the applications is picked to handle URLs of that type."

The solution then is to create a share sheet that checks for all of the registered urlSchemes that adhere to the proposed format. If your Bible app wishes to join you must:

1) Submit your specific urlScheme here. The naming convention for this will be "bible-yourappname://"

2) Commit to parsing the incoming data as well as being able to share through the action sheet. Our goal will be to put together some helper classes here for iOS to get things started.

## Universal Share Sheet

How then will the "common share sheet" function? It will simply go through the list of registered schemes and ask the OS which ones it can open. Only those will be shown by default. You will also have the option to specifically turn on apps which you'd like the user to see as an option regardless of whether they have them or not. If the user does not have them, they will be directed to the app store for download. This then allows certain apps to encourage their users to check out complementary apps.

We will have the default style be system only. Customization will be allowed.

Each listing then will need the follow:

1) The specific urlScheme.

2) An intention, currently there are 3 options: Read, Study, Memorize.

3) A link to the App Store.

Note, that the urlScheme's query will include an "intention" variable at the end. If it is passed into the share sheet with that intention then the share sheet will scope the list to only those options.

## Universal Query Format

The format that we will use to pass information will support the following cases:

* Sharing a single passage (Passage being defined as any number of disjointed references found within a single chapter of a single book)
* Sharing multiple passages
* Sharing a single chapter
* Sharing multiple chapters (Multiple chapters)
* Sharing a single book
* Sharing with one of the three above mentioned intentions (Read, Study, Memorize)
* Sharing with a intended translation (we will have a standardized list for these too)

Example of the format:

`bible-yourappname://intention?passages=[Gen.1.1-Gen.1.4,Gen1.8],[Exo.1.1-Exo.1.8],[Rev.1-Rev.7]&translation=ESV2011`

To share a passage:
`[Gen.1.1-Gen.1.4,Gen1.8]`

To share multiple passages:
`[Gen.1.1-Gen.1.4,Gen1.8],[Exo.1.1-Exo.1.8]`

To share a chapter:
`[Gen.1]`

To share multiple chapters:
`[Gen.1-7]` or `[Gen.1-Gen.7]`

To share a book:
`[Gen]`

### Community Status

Current apps:

Verses - Status: Integraing, Primary Intention: Memorize, Other Intentions: nil

ESV Bible - Status: Interested, Primary Intention: Read, Other Intentions: Study

### Standard Naming Conventions

[OSIS](http://www.crosswire.org/wiki/OSIS_Book_Abbreviations) Book Abbreviation Standards:
`.plist` files are available in this repo of the standardized abbreviation and full names 

### Standard list for Translations:

To be added.

### References
[OSIS](http://www.crosswire.org/wiki/OSIS_Book_Abbreviations) - CrossWire Wiki

[OSIS Wikipedia](http://en.wikipedia.org/wiki/Open_Scripture_Information_Standard) - General Description of OSIS

[OSIS Manual (PDF)](http://img.forministry.com/7/7B/7BB51FB8-84B3-4FF3-939ED473FA90A632/DOC/OSIS2_1UserManual_06March2006_-_with_O'Donnell_edits.PDF) - references are described on page 88

[Bible Passage Reference Parser](https://github.com/openbibleinfo/Bible-Passage-Reference-Parser) - javascript library for parsing text for bible references. Implements OSIS reference standard

[IntentKit](https://github.com/intentkit/IntentKit) - A cocoapod that impliments similar functionality as our share sheet.
