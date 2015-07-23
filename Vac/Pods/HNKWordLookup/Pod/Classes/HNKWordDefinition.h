//
//  HNKWordDefinition.h
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Mantle/Mantle.h>

/**
 Parts of speech

 @discussion `HNKWordDefinitionPartOfSpeech` is an enum, so its values support
 math operations.

 The underlying values are bitmasked to facilitate being combined together
 with an `|` operator. See: http://apple.co/ZP4eyl

 Note: Excluding the default value `HNKWordDefinitionPartOfSpeechUnknown`,
 the enum values are in alphabetical order by part of speech - e.g. Adjective
 comes before Adverb.
 */
typedef NS_OPTIONS(NSInteger, HNKWordDefinitionPartOfSpeech) {
  HNKWordDefinitionPartOfSpeechUnknown = 0,
  HNKWordDefinitionPartOfSpeechAbbreviation = 1 << 0,
  HNKWordDefinitionPartOfSpeechAdjective = 1 << 1,
  HNKWordDefinitionPartOfSpeechAdverb = 1 << 2,
  HNKWordDefinitionPartOfSpeechAffix = 1 << 3,
  HNKWordDefinitionPartOfSpeechArticle = 1 << 4,
  HNKWordDefinitionPartOfSpeechArticleDefinite = 1 << 5,
  HNKWordDefinitionPartOfSpeechConjunction = 1 << 6,
  HNKWordDefinitionPartOfSpeechIdiom = 1 << 7,
  HNKWordDefinitionPartOfSpeechImperative = 1 << 8,
  HNKWordDefinitionPartOfSpeechInterjection = 1 << 9,
  HNKWordDefinitionPartOfSpeechNameFamily = 1 << 10,
  HNKWordDefinitionPartOfSpeechNameGiven = 1 << 11,
  HNKWordDefinitionPartOfSpeechNoun = 1 << 12,
  HNKWordDefinitionPartOfSpeechNounPlural = 1 << 13,
  HNKWordDefinitionPartOfSpeechNounPosessive = 1 << 14,
  HNKWordDefinitionPartOfSpeechNounProper = 1 << 15,
  HNKWordDefinitionPartOfSpeechNounProperPlural = 1 << 16,
  HNKWordDefinitionPartOfSpeechNounProperPosessive = 1 << 17,
  HNKWordDefinitionPartOfSpeechParticiplePast = 1 << 18,
  HNKWordDefinitionPartOfSpeechPrefixPhrasal = 1 << 19,
  HNKWordDefinitionPartOfSpeechPreposition = 1 << 20,
  HNKWordDefinitionPartOfSpeechPronoun = 1 << 21,
  HNKWordDefinitionPartOfSpeechSuffix = 1 << 22,
  HNKWordDefinitionPartOfSpeechVerb = 1 << 23,
  HNKWordDefinitionPartOfSpeechVerbAuxiliary = 1 << 24,
  HNKWordDefinitionPartOfSpeechVerbIntransitive = 1 << 25,
  HNKWordDefinitionPartOfSpeechVerbPhrasal = 1 << 26,
  HNKWordDefinitionPartOfSpeechVerbTransitive = 1 << 27
};

@interface HNKWordDefinition : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *definitionText;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, assign) HNKWordDefinitionPartOfSpeech partOfSpeech;
@property (nonatomic, copy) NSString *attribution;

/**
 *  String equivalent for partOfSpeech
 */
- (NSString *)partOfSpeechString;

@end