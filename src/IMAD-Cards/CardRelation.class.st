"
I represent a named relationship from one card (the source) to another (the target).
I support filtering operations to retrieve relations.

NB: my name is a symbol rather than a string.


"
Class {
	#name : #CardRelation,
	#superclass : #AbstractCardModelEntity,
	#instVars : [
		'source',
		'target',
		'deck',
		'kind'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
CardRelation >> <= aRelation [
	^ self source name < aRelation source name
		or: [ self source name = aRelation source name
				and: [ self kind < aRelation kind
						or: [ self kind = aRelation kind
								and: [ self target name <= aRelation target name ] ] ] ]
]

{ #category : #comparing }
CardRelation >> = anObject [
	"Answer whether the receiver and anObject represent the same object.
	NB: Do NOT also compare if the decks are equal, or this will lead to infinite recursion!"

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self kind = anObject kind
		and:
			[ self source = anObject source and: [ self target = anObject target ] ]
]

{ #category : #initialization }
CardRelation >> assertInvariant [
	"NB: duplicated code with Card>>#assertInvariant"

	"super assertInvariant."

	self assert: self deck isNotNil description: 'deck must be defined'.
	self
		assert: (self deck isKindOf: CardDeck)
		description: 'deck must be a CardDeck'.
	self assert: self kind isNotNil description: 'kind of relation must be defined'.
	self assert: self kind isString description: 'kind must be a string'.
	self
		assert: self kind notEmpty
		description: 'kind must not be an empty string'.
	self
		assert: (source isKindOf: Card)
		description: 'source must be a Card'.
	self
		assert: (target isKindOf: Card)
		description: 'target must be a Card'
]

{ #category : #accessing }
CardRelation >> deck [
	^ deck
]

{ #category : #accessing }
CardRelation >> deck: aCardDeck [
	deck := aCardDeck
]

{ #category : #removing }
CardRelation >> delete [
	self deck deleteRelation: self.
	self deck: nil
]

{ #category : #accessing }
CardRelation >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 5;
		stencil: [ | content |
			content := BlElement new
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				layout: BlLinearLayout horizontal.
			content
				addChildren:
					{
					(self
						editableLabelFor: self source
						withSetter: [ :arg | self source: (self deck cardNamed: arg) ]).
					(self labelFor: 'is').
					(self
						editableLabelFor: self kind
						withSetter: [ :arg | self kind: arg ]).
					(self labelFor: 'of').
					(self
						editableLabelFor: self target
						withSetter: [ :arg | self target: (self deck cardNamed: arg) ])}.
			content ];
		updateWhen: RelationsUpdated in: [ self announcer ];
		updateWhen: CardsUpdated in: [ self announcer ]
]

{ #category : #accessing }
CardRelation >> hasSource: aCard [
	^ source = aCard
]

{ #category : #accessing }
CardRelation >> hasTarget: aCard [
	^ target = aCard
]

{ #category : #comparing }
CardRelation >> hash [
	"Answer a SmallInteger whose value is related to the receiver's identity.
	May be overridden, and should be overridden in any classes that define = "

	^ self identityHash 
]

{ #category : #accessing }
CardRelation >> initializeDeck: aDeck kind: aSymbol source: aSourceCard target: aTargetCard [
	deck := aDeck.
	kind := aSymbol.
	source := aSourceCard.
	target := aTargetCard.
	self assertInvariant
]

{ #category : #accessing }
CardRelation >> isOfKind: aSymbol [
	^ kind = aSymbol
]

{ #category : #accessing }
CardRelation >> kind [
	^ kind
]

{ #category : #accessing }
CardRelation >> kind: aSymbol [
	kind := aSymbol.
	self deck announcer announce: RelationsUpdated
]

{ #category : #accessing }
CardRelation >> name: aSymbol [
	self deprecated: 'use kind: instead'.
	kind := aSymbol.
	self deck announcer announce: RelationsUpdated
]

{ #category : #printing }
CardRelation >> printOn: aStream [
	aStream
		nextPutAll: self kind;
		nextPutAll: ' : '.
	self source printOn: aStream.
	aStream
		nextPutAll: ' -> '.
	self target printOn: aStream
]

{ #category : #accessing }
CardRelation >> source [
	^ source
]

{ #category : #accessing }
CardRelation >> source: aCard [
	source := aCard.
	self deck announcer announce: RelationsUpdated
]

{ #category : #accessing }
CardRelation >> target [
	^ target
]

{ #category : #accessing }
CardRelation >> target: aCard [
	target := aCard.
	self deck announcer announce: RelationsUpdated
]
