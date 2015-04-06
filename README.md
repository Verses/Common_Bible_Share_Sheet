# Purpose
Our goal is to create a common share sheet for Bible apps (starting with iOS). Imagine you're reading a passage in YouVersion and want to get a bit more contextual information: so you open that passage in Logos. Or say you are reading a passage in NeuBible and decide you want to start memorizing it: you can open it in Verses. Or if you are memorizing a passage in Verses and want to read it in context: you can open it inside the ESV Bible app.

## Goals
While the foremost goal is to create a link between apps a secondary goal is to create a standard query that each of these schemes accepts. That way websites, etc, will be able to know how to create links that are openable within a Bible app.

Ideally we would use a single urlScheme, something like `bible://` but unfortunantly iOS doesnt support this. According to Apple it is "undefined as to which of the applications is picked to handle URLs of that type."

The solution then is to create a share sheet that checks for all of the registered urlSchemes that adhere to the proposed format. If your Bible app wishes to join you are expected to integrate on both ends of sending and recieving. Practically this looks like 1) inlcuding the universal share sheet and 2) supporting the parsing of the universal query format.

### Universal Share Sheet

How then will the "common share sheet" function? It will simply go through the list of registered schemes and ask the OS which ones it can open. Only those will be shown by default. You will also have the option to specifically turn on apps which you'd like the user to see as an option regardless of whether they have them or not. If the user does not have them, they will be directed to the app store for download. This then allows certain apps to encourage their users to check out complementary apps.

We will have the default style be system only (currently uses a UIActionSheet style). Customization will be allowed.

Each listing then will need the follow:

1. The specific urlScheme (naming convention: bible-yourappname://).

2. At least one supported intention, currently there are 4 options: Read, Study, Memorize, Listen.

3. A link to the App Store.

### Universal Query Format

The format that we will use to pass information will support the following cases:

* Sharing a single passage (Passage being defined as any number of disjointed references found within a single chapter of a single book)
* Sharing multiple passages
* Sharing a single chapter
* Sharing multiple chapters (Multiple chapters)
* Sharing a single book
* Sharing with one of the three above mentioned intentions (Read, Study, Memorize)
* Sharing with a intended translation (we will have a standardized list for these too)

Example of the format:

`bible-yourappname://?passages=[Gen.1.1-Gen.1.4,Gen1.8],[Exo.1.1-Exo.1.8],[Rev.1-Rev.7]&translation=ESV2011&intention="Read"`

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

## Using

1. Clone this repository
2. Implement the OSIS protocol to map your internal representation of groups of verses to valid references
3. Add the CommonShareSheetHelper and BibleApp files

## Contributing

Obviously this initiative only works with community buy-in. To include your app in the project:

1. Fork the [repo]( https://github.com/Verses/Common_Bible_Share_Sheet/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
  1. add your custom url scheme, supported intentions, and iTunes url to `apps.plist`
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Roadmap
- [ ] v0.6 - working share sheet
- [ ] v0.7 - restructure to use plist for all supported apps and intentions
- [ ] v0.8 - OSIS parsing and generation helpers
- [ ] v0.9 - working share sheet with multiple apps
- [ ] v1.0 - convert repository to cocoapod for easy inclusion and version management in projects

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
