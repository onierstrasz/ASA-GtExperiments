"
I test the querying of CardRelations using filters.
I use a simple deck of three cards labeled A, B and C, connected by relations w, x, y and z.
"
Class {
	#name : #CardRelationFilterTestExamples,
	#superclass : #Object,
	#instVars : [
		'deck'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasOneSourceCardNamedA [
	<gtExample>
	| filter result |
	filter := CRSourceFilter new source: (deck cardNamed: 'A').
	result := deck relationsMatching: filter.
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasRelationX [
	<gtExample>
	| filter result |
	filter := CRRelNameFilter new name: #x.
	result := deck relationsMatching: filter.
	self assert: result size equals: 2.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasRelationXorY [
	<gtExample>
	| filter filterX filterY result |
	filterX := CRRelNameFilter new name: #x.
	filterY := CRRelNameFilter new name: #y.
	filter := filterX | filterY.
	result := deck relations select: [:rel | filter matches: rel].
	self assert: result size equals: 3.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasSixRelations [
	<gtExample>
	self assert: deck relations size equals: 6.
	^ deck relations
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasSourceAandRelationX [
	<gtExample>
	| cardA filter filterA filterX result |
	cardA := deck cardNamed: 'A'.
	filterA := CRSourceFilter new source: cardA.
	filterX := CRRelNameFilter new name: #x.
	filter := filterA & filterX.
	result := deck relationsMatching: filter.
	self assert: result size equals: 1.
	self assert: (cardA hasA: #x).
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasSourceAandTargetB [
	<gtExample>
	| cardA cardB filter filterA filterB result |
	cardA := deck cardNamed: 'A'.
	cardB := deck cardNamed: 'B'.
	filterA := CRSourceFilter new source: cardA.
	filterB := CRTargetFilter new target: cardB.
	filter := filterA & filterB.
	result := deck relationsMatching: filter.
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasSourceCardNamedA [
	<gtExample>
	| filter result |
	filter := CRSourceFilter new source: (deck cardNamed: 'A').
	result := deck relations select: [:rel | filter matches: rel].
	self assert: result size equals: 1.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasThreeSourceCardsNamedB [
	<gtExample>
	| filter result |
	filter := CRSourceFilter new source: (deck cardNamed: 'B').
	result := deck relationsMatching: filter.
	self assert: result size equals: 3.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> deckHasTwoTargetCardsNamedB [
	<gtExample>
	| filter result |
	filter := CRTargetFilter new target: (deck cardNamed: 'B').
	"result := deck relations select: [:rel | filter matches: rel]."
	result := deck relationsMatching: filter.
	self assert: result size equals: 2.
	^ result
]

{ #category : #accessing }
CardRelationFilterTestExamples >> initialize [
	self setupModel
]

{ #category : #accessing }
CardRelationFilterTestExamples >> setupModel [
	<gtExample>
	| a b c |
	deck := CardDeck new.
	a := Card new name: 'A'.
	b := Card new name: 'B'.
	c := Card new name: 'C'.
	deck
		addCard: a;
		addCard: b;
		addCard: c.
	b become: #x of: a.
	a become: #x of: b.
	c become: #y of: b.
	a become: #z of: c.
	b become: #w of: b.
	c become: #w of: c.
	^ deck
]