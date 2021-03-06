"
I am a holder of information about a domain concept in a domain model.
I provide a UI to enter, edit and manipulate this information.

I have a name, a description, and other properties.
My name is unique within a Card Deck.

NB: properties should just hold (flat?) values, so the deck of a card should not be modeled as a property.


"
Class {
	#name : #Card,
	#superclass : #AbstractCardModelNamedEntity,
	#instVars : [
		'deck'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
Card >> <= aCard [
	^ self name <= aCard name
]

{ #category : #tags }
Card >> addTag: aString [
	<todo:
		'Should we announce to the deck only if it is a new tag? (Would require the deck to keep track.)'>
	(self tags includes: aString)
		ifFalse: [ self tags add: aString.
			self announcer announce: TagsUpdated new.
			self deckAnnounce: TagsUpdated new ]
]

{ #category : #accessing }
Card >> addTags: aTagCollection [
	aTagCollection do: [ :each | self addTag: each ]
]

{ #category : #accessing }
Card >> announceCardsUpdated [
	self deck ifNotNil: [ :d | d announcer announce: CardsUpdated new ]

]

{ #category : #initialization }
Card >> assertInvariant [
	"NB: We can only assert the invariant after a card has been added to a deck.
	A new Card is detached and will not satisfy the invariant."

	super assertInvariant.
	self assert: self deck isNotNil description: 'deck must be defined'.
	self
		assert: (self deck isKindOf: CardDeck)
		description: 'deck must be a CardDeck'
]

{ #category : #initialization }
Card >> assertUniqueName: aString [
	self deck
		ifNotNil: [ :d | 
			self
				assert: ((d cards collect: #name) includes: aString) not
				description: 'cards must be uniquely named' ]
]

{ #category : #relations }
Card >> become: relation of: aSourceCard [
	"Convenience method"
	self deck addRelation: relation from: aSourceCard to: self
]

{ #category : #accessing }
Card >> buildHeaderPane [
	| header |
	header := super buildHeaderPane.
	header addChild: self buildTagHeader.
	^ header
]

{ #category : #tags }
Card >> buildTagHeader [
	"See BrTaggerExamples>>#newGlamorousTagger and UsefulExamples>>#cardTagger"

	<todo:
		'Fix bug with adding deleting and adding, or adding 3x raising an exception. See IMAD issue #23'>
	| tagger |
	tagger := BrTagger new
		aptitude: BrGlamorousTaggerEditableAptitude new;
		namedTags: self tags;
		when: BrTaggerAddTagRequest
			do:
				[ :aRequest | aRequest tag name ifNotEmpty: [ self addTag: aRequest tag name ] ];
		when: BrTaggerRemoveTagRequest
			do: [ :aRequest | self removeTagNamed: aRequest tag name ];
		when: BrTaggerRenameTagRequest
			do: [ :aRequest | 
			aRequest newName trimmed
				ifEmpty: [ self removeTagNamed: aRequest tag name ]
				ifNotEmpty: [ :aNewName | self renameTagNamed: aRequest tag name to: aNewName ] ].
	self announcer
		when: TagsUpdated
		do: [ tagger namedTags: self tags ]
		for: self.
	^ tagger
]

{ #category : #relations }
Card >> connectTo: aTargetCard [
	"Convenience method"

	self deck
		addRelation: '_rel' , Object new identityHash asString
		from: self
		to: aTargetCard
]

{ #category : #accessing }
Card >> deck [
	^ deck
]

{ #category : #accessing }
Card >> deck: aCardDeck [
	deck := aCardDeck
]

{ #category : #tags }
Card >> deckAnnounce: anAnnouncement [
	self deck isNotNil
		ifTrue: [ self deck announcer announce: anAnnouncement ]
]

{ #category : #accessing }
Card >> delete [
	self deck deleteCard: self.
	self deck: nil
]

{ #category : #relations }
Card >> deleteRelations [
	self relations do: [ :each | each delete ]
]

{ #category : #accessing }
Card >> description: aString [
	super description: aString.
	self announceCardsUpdated
]

{ #category : #'gt-extensions' }
Card >> gtDeckInspectorFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons upwards;
		forViewDefinedIn: #gtDescriptionFor:;
		priority: 50;
		tooltip: 'Inspect Card Deck';
		action: [ :button | 
			self deck inspect ]
]

{ #category : #'gt-extensions' }
Card >> gtSaveMainActionFor: anAction [
	"Copy save action to main tab as well"

	<gtAction>
	^ (self deck gtSaveActionFor: anAction)
		forViewDefinedIn: #gtDescriptionFor:
]

{ #category : #querying }
Card >> hasA: relSymbol [
	^ (self deck
		relationsMatching: relSymbol asRelNameFilter & self sourceFilter)
		isNotEmpty
]

{ #category : #accessing }
Card >> hasTagNamed: aTag [
	^ self tags includes: aTag
]

{ #category : #initialization }
Card >> initialize [
	super initialize.
	"tags := OrderedCollection new"
	self set: #tags to: OrderedCollection new
	"self assertInvariant"
]

{ #category : #querying }
Card >> is: relSymbol of: aCard [
	^ (self deck
		relationsMatching:
			relSymbol asRelNameFilter & aCard sourceFilter & self targetFilter)
		isNotEmpty
]

{ #category : #querying }
Card >> isA: relSymbol [
	^ (self deck
		relationsMatching: relSymbol asRelNameFilter & self targetFilter)
		isNotEmpty
]

{ #category : #accessing }
Card >> name: aString [
	self assertUniqueName: aString.
	super name: aString.
	self announceCardsUpdated
]

{ #category : #querying }
Card >> relations [
	^ self sourceRelations
		addAll: self targetRelations;
		yourself
]

{ #category : #tags }
Card >> removeTagNamed: aTagString [
	(self tags includes: aTagString)
		ifFalse: [ ^ self ].
	self tags remove: aTagString.
	self announcer announce: TagsUpdated new.
	self deckAnnounce: TagsUpdated new
]

{ #category : #tags }
Card >> renameTagNamed: aTagString to: aNewTagString [
	(self tags includes: aTagString)
		ifFalse: [ ^ self ].
	self tags remove: aTagString.
	(self tags includes: aNewTagString)
		ifFalse: [ self tags add: aNewTagString ].
	self announcer announce: TagsUpdated new.
	self deckAnnounce: TagsUpdated new
]

{ #category : #properties }
Card >> set: propertyKey to: aValue [
	super set: propertyKey to: aValue.
	self announceCardsUpdated
]

{ #category : #querying }
Card >> sourceFilter [
	^ CRSourceFilter new source: self.
]

{ #category : #querying }
Card >> sourceRelations [
	^ self deck relationsMatching: self sourceFilter
]

{ #category : #printing }
Card >> storeOn: aStream [
	aStream
		nextPutAll: 'Card new';
		cr.
	self
		storeNameAndDescriptionOn: aStream;
		"storeTagsOn: aStream;"
		storePropertiesOn: aStream.
	aStream nextPutAll: '  yourself'
]

{ #category : #accessing }
Card >> tags [
	^ self get: #tags
]

{ #category : #querying }
Card >> targetFilter [
	^ CRTargetFilter new target: self
]

{ #category : #querying }
Card >> targetRelations [
	^ self deck relationsMatching: self targetFilter
]
