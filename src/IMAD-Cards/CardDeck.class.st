Class {
	#name : #CardDeck,
	#superclass : #Object,
	#instVars : [
		'cards'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
CardDeck >> add: aCard [
	cards add: aCard
]

{ #category : #accessing }
CardDeck >> cardNamed: aString [
	| result |
	result := cards select: [:each | each name = aString].
	self assert: result size equals: 1.
	^ result at: 1
]

{ #category : #accessing }
CardDeck >> cardsNamed: aString [
	^ cards select: [:each | each name = aString]
]

{ #category : #accessing }
CardDeck >> gtCardsFor: aView [
	<gtView>
	^ aView forward
		title: 'Cards';
		priority: 2;
		object: [ cards ];
		view: #gtItemsFor:
]

{ #category : #accessing }
CardDeck >> initialize [
	super initialize.
	cards := OrderedCollection new.
]

{ #category : #accessing }
CardDeck >> isEmpty [
	^ cards isEmpty
]

{ #category : #accessing }
CardDeck >> listTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]