"
I test that a VirtualHand is properly synchronized with its CardDeck.

The Deck has cards with tags 'a' and 'b'.
The Hand is defined by the filter 'a' & not 'b'.
# Tests:
Adding a Card to a Hand adds it to the Deck, and ensures that the Card has the tags it needs to pass the Hand's Filter. The hand should automatically set all the positive tags (need to ask a filter for all its positive tags)

{{gtMethod:name=CardHandTestExamples>>#addCardToHand}}

Adding a Relation to a Hand adds it to the Deck. (The source and target already must be in the Hand.)
{{gtMethod:name=CardHandTestExamples>>#addRelationToHand}}

Adding a Card or Relation to a Deck might add it to the Hand. The Filter will need to be reevaluated.
{{gtMethod:name=CardHandTestExamples>>#addCardToDeck}}

{{gtMethod:name=CardHandTestExamples>>#addRelationToDeck}}

Deleting a Card or Relation from a Deck deletes it from the Hand.
{{gtMethod:name=CardHandTestExamples>>#deleteCardFromDeck}}

{{gtMethod:name=CardHandTestExamples>>#deleteRelationFromDeck}}

Deleting a Card or Relation  from a Hand also deletes it from the Deck.
{{gtMethod:name=CardHandTestExamples>>#deleteCardFromHand}}

{{gtMethod:name=CardHandTestExamples>>#deleteRelationFromHand}}

Adding a tag to a card or removing it may remove it from the hand (and add it to another hand) -- need test with two hands

{{gtMethod:name=CardHandTestExamples>>#addTagToCard}}

{{gtMethod:name=CardHandTestExamples>>#deleteTagFromCard}}


"
Class {
	#name : #CardHandTestExamples,
	#superclass : #Object,
	#instVars : [
		'deck',
		'hand'
	],
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardHandTestExamples >> addCardToDeck [
	"Adding a Card or Relation to a Deck might add it to the Hand. The Filter will need to be reevaluated.
	Adding a new Card directly to a deck should trigger a CardsUpdated event, causing the Hand to invalidate (and recompute) its Cards."

	<gtExample>
	self assert: (hand hasCardNamed: 'a3') not.
	self assert: (deck hasCardNamed: 'a3') not.
	self assert: (deck announcer hasSubscriber: hand).
	self assert: hand cardsNil not.
	deck
		addCard:
			(Card new
				name: 'a3';
				addTag: 'a';
				yourself).
	self assert: hand cardsNil.
	deck
		addCard:
			(Card new
				name: 'b3';
				addTag: 'b';
				yourself).
	self assert: (hand hasCardNamed: 'a3').
	self assert: (deck hasCardNamed: 'a3').
	self assert: (hand hasCardNamed: 'b3') not.
	self assert: (deck hasCardNamed: 'b3').
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> addCardToHand [
	"Adding a Card to a Hand adds it to the Deck, and ensures that the Card has the tags it needs to pass the Hand's Filter. The hand should automatically set all the positive tags (need to ask a filter for all its positive tags)"

	<gtExample>
	self assert: (hand hasCardNamed: 'a3') not.
	self assert: (deck hasCardNamed: 'a3') not.

	"The tag 'a' should be automatically added"
	hand
		addCard:
			(Card new
				name: 'a3';
				yourself).
	self assert: (hand hasCardNamed: 'a3').
	self assert: (deck hasCardNamed: 'a3').
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> addRelationToDeck [
	"Adding a Card or Relation to a Deck might add it to the Hand.
The Filter will need to be reevaluated."

	<gtExample>
	self assert: (hand hasCardNamed: 'a2').
	self assert: (hand hasCardNamed: 'ac1').
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not.
	deck addRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1'.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> addRelationToHand [
	"Adding a Relation to a Hand adds it to the Deck. (The source and target already must be in the Hand.)"

	<gtExample>
	self assert: (hand hasCardNamed: 'a2').
	self assert: (hand hasCardNamed: 'ac1').
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not.
	hand addRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1'.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> addTagToCard [
	"Adding a tag to a card or removing it may remove it from the hand (and add it to another hand) -- need test with two hands"

	<gtExample>
	| c1 |
	c1 := deck cardNamed: 'c1'.
	self assert: (deck hasCardNamed: 'c1').
	self assert: (hand hasCardNamed: 'c1') not.
	c1 addTag: 'a'.
	
	"HERE we need to make sure that hand subscribes to tag changes"
	
	
	
	"hand invalidateCardsAndRelations."
	
	
	self assert: (hand hasCardNamed: 'c1')
]

{ #category : #accessing }
CardHandTestExamples >> deckHasTenCards [
	<gtExample>
	self assert: deck cards size equals: 10.
	^ deck
]

{ #category : #accessing }
CardHandTestExamples >> deckHasThreeTags [
	<gtExample>
	self assert: deck tags size equals: 3.
	self assert: deck tags asSet equals: {'a' . 'b' . 'c'} asSet.
	^ deck
]

{ #category : #accessing }
CardHandTestExamples >> deleteCardFromDeck [
	"Deleting a Card or Relation from a Deck deletes it from the Hand."

	<gtExample>
	self addCardToDeck.
	self assert: (hand hasCardNamed: 'a3').
	deck deleteCardNamed: 'a3'.
	self assert: (hand hasCardNamed: 'a3') not
]

{ #category : #accessing }
CardHandTestExamples >> deleteCardFromHand [
	"Deleting a Card or Relation  from a Hand also deletes it from the Deck."

	<gtExample>
	self addCardToHand.
	self assert: (hand hasCardNamed: 'a3').
	self assert: (deck hasCardNamed: 'a3').
	hand deleteCardNamed: 'a3'.
	self assert: (hand hasCardNamed: 'a3') not.
	self assert: (deck hasCardNamed: 'a3') not.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> deleteRelationFromDeck [
	"Deleting a Card or Relation from a Deck deletes it from the Hand."

	<gtExample>
	self addRelationToDeck.
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	deck deleteRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1'.
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not
]

{ #category : #accessing }
CardHandTestExamples >> deleteRelationFromHand [
	"Deleting a Card or Relation  from a Hand also deletes it from the Deck."

	<gtExample>
	self addRelationToDeck.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1').
	hand deleteRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1'.
	self
		assert: (deck hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not.
	self
		assert: (hand hasRelation: 'a-ac' fromCardNamed: 'a2' toCardNamed: 'ac1') not
]

{ #category : #accessing }
CardHandTestExamples >> deleteTagFromCard [
	"Adding a tag to a card or removing it may remove it from the hand (and add it to another hand) -- need test with two hands"

	<gtExample>
	self addCardToHand.
	self assert: (hand hasCardNamed: 'a3').
	self assert: (deck hasCardNamed: 'a3').
	(deck cardNamed: 'a3') removeTagNamed: 'a'.
	self assert: (hand hasCardNamed: 'a3') not.
	self assert: (deck hasCardNamed: 'a3').
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> exampleDeck [
	<storedCardDeck>
	<gtExample>
	^ CardDeck new
		name: 'CardHandTestExample Deck';
		description:
			'I test that a CardHand is properly synchronized with its CardDeck.

Adding a Card or Relation to a Hand adds it to the Deck.
Adding a Card or Relation to a Deck might add it to the Hand.
The Filter will need to be reevaluated.
Deleting a Card or Relation from a Deck deletes it from the Hand.
Deleting a Card or Relation  from a Hand also deletes it from the Deck.';
		properties:
			(Dictionary new
				add: #storageClassName -> 'CardHandTestExamples';
				add: #storageMethodName -> 'exampleDeck';
				yourself);
		addCard:
			(Card new
				name: 'a1';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'a';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'a2';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'a';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'ab1';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'a';
										add: 'b';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'ab2';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'a';
										add: 'b';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'ac1';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'a';
										add: 'c';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'ac2';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'a';
										add: 'c';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'b1';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'b';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'b2';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'b';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'c1';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'c';
										yourself);
						yourself);
				yourself);
		addCard:
			(Card new
				name: 'c2';
				description: 'To do';
				properties:
					(Dictionary new
						add:
							#tags
								->
									(OrderedCollection new
										add: 'c';
										yourself);
						yourself);
				yourself);
		addRelation: 'a-a' fromCardNamed: 'a1' toCardNamed: 'a2';
		addRelation: 'a-ab' fromCardNamed: 'a1' toCardNamed: 'ab1';
		addRelation: 'a-ac' fromCardNamed: 'a1' toCardNamed: 'ac1';
		addRelation: 'a-ac' fromCardNamed: 'a1' toCardNamed: 'ac2';
		addRelation: 'a-b' fromCardNamed: 'a1' toCardNamed: 'b1';
		addRelation: 'ab-ab' fromCardNamed: 'ab1' toCardNamed: 'ab2';
		addRelation: 'ab-c' fromCardNamed: 'ab1' toCardNamed: 'c2';
		addRelation: 'b-b' fromCardNamed: 'b1' toCardNamed: 'b2';
		addRelation: 'b-c' fromCardNamed: 'b1' toCardNamed: 'c1';
		yourself
]

{ #category : #accessing }
CardHandTestExamples >> handHasFourCards [
	<gtExample>
	self assert: hand cards size equals: 4.
	self assert: (hand hasCardNamed: 'a1') .
	self assert: (hand hasCardNamed: 'a2') .
	self assert: (hand hasCardNamed: 'ac1') .
	self assert: (hand hasCardNamed: 'ac2') .
	self assert: (hand hasCardNamed: 'ab1') not.
	self assert: (hand hasCardNamed: 'b1') not.
	self assert: (hand hasCardNamed: 'c1') not.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> handHasThreeRelations [
	<gtExample>
	self assert: hand relations size equals: 3.
	self
		assert: (hand relationsMatching: 'a-a' asRelNameFilter) size
		equals: 1.
	self
		assert: (hand relationsMatching: 'a-ac' asRelNameFilter) size
		equals: 2.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> handHasThreeTags [
	"Note that although the hand specifies '~b' as a filter, so there are no cards with a 'b' tag, it is still considered to be a relevant tag and must be displayed."

	<gtExample>
	self assert: hand tags size equals: 3.
	self assert: hand tags asSet equals: {'a' . 'b' . 'c'} asSet.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> handWithExtendedFilterHasFourTags [
	"Note that the tag 'd' appears in no card of either the hand or the deck but only in the filter."

	<gtExample>
	self assert: hand tags size equals: 3.
	hand filter: hand filter | 'd' asTagFilter not.
	self assert: hand tags size equals: 4.
	self assert: hand tags asSet equals: {'a' . 'b' . 'c' . 'd'} asSet.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> handWithTrueFilterHasTenCards [
	<gtExample>
	hand filter: TrueFilter new.
	self assert: hand cards size equals: 10.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> handWithTrueFilterHasThreeTags [
	<gtExample>
	self handWithTrueFilterHasTenCards.
	self assert: hand tags size equals: 3.
	self assert: hand tags asSet equals: {'a' . 'b' . 'c'} asSet.
	^ hand
]

{ #category : #accessing }
CardHandTestExamples >> initialize [
	deck := self exampleDeck.
	hand := VirtualHand new
		deck: deck
		filter: 'a' asTagFilter & ('b' asTagFilter not)
]
