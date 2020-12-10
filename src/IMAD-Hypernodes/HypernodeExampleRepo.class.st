"
I am a repository of test examples.

A Hypernode instance can be saved to me by setting the properties storageClassName and storageMethodName as in the following example:

[[[
eg := HypernodeTestExamples new flatGraphWithNodeProperties .
eg set: 'storageClassName' to: 'HypernodeExampleRepo'.
eg set: 'storageMethodName' to: 'flatGraphWithNodeProperties'.
eg saveState
]]]


"
Class {
	#name : #HypernodeExampleRepo,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #'as yet unclassified' }
HypernodeExampleRepo >> flatGraphWithNodeProperties [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add: 'storageClassName' -> 'HypernodeExampleRepo';
						add: 'storageMethodName' -> 'flatGraphWithNodeProperties';
						yourself);
				yourself)
			for: 1;
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add:
							#nested
								->
									((Array new: 3)
										at: 1 put: #a -> 1;
										at: 2 put: #b -> 2;
										at: 3
											put:
											#c
												->
													(Dictionary new
														add: #x -> 'hello';
														add:
															#y
																->
																	(OrderedCollection new
																		add: 'hi';
																		add: 'there';
																		yourself);
														yourself);
										yourself);
						yourself);
				yourself)
			for: 2;
		addNode: Hypernode new yourself for: 3;
		addSubNodes: {2 . 3} for: 1;
		addEdgeFrom: 2
			to: 3
			for: 1
			withProperties: Dictionary new;
		nodeForId: 1
]