"
I provide a dedicated view for a {{gtClass:Hypernode}} instance as a node within a graph.

"
Class {
	#name : #HypernodeElement,
	#superclass : #AbstractHypernodeElement,
	#instVars : [
		'nodeContext'
	],
	#category : #'IMAD-Hypernodes-View'
}

{ #category : #accessing }
HypernodeElement class >> forContext: aNodeContext [
	^ self new
		context: aNodeContext;
		yourself
]

{ #category : #accessing }
HypernodeElement >> container [
	"Return the graph container for this node. See: HypernodeEditor>>#buildGraphContainer"

	| container graph graphHolder |
	graph := self parent.
	self assert: (graph isKindOf: HypernodeGraphElement).
	graphHolder := graph parent.
	self assert: (graphHolder isKindOf: BlPinchableElement).
	container := graphHolder parent.
	self assert: (container isKindOf: BlPannableElement).
	^ container
]

{ #category : #accessing }
HypernodeElement >> context [
	^ nodeContext
]

{ #category : #accessing }
HypernodeElement >> context: aNodeContext [
	<todo: 'update the configurable look from the context'>
	self assert: aNodeContext isNotNil.
	nodeContext := aNodeContext.
	self aptitude: nodeContext graphStyle nodeAptitude.
	self handleEvents.
	self graph model: aNodeContext node.
	self subscribe
]

{ #category : #accessing }
HypernodeElement >> contextMenu [
	<todo: 'add more context menu actions for nodes'>
	| menu |
	menu := BrGlamorousSimpleContextMenuContent new
		items:
			{('Inspect node' -> [ self node inspect ]).
			('Delete node from parent'
				-> [ "menu anchor: BlElement new."
					self context delete ])};
		yourself.
	^ menu
]

{ #category : #accessing }
HypernodeElement >> defaultLook [
	^ HNConfigurableAptitude
		configuration:
			{(#borderColor -> #black).
			(#hoverColor -> #red).
			(#text -> '').
			(#shape -> #circle)}
]

{ #category : #accessing }
HypernodeElement >> defaultPadding [
	^ 5
]

{ #category : #accessing }
HypernodeElement >> handleEvents [
	<todo:
		'Move the context menu and double-click handling to the configurable look (or the graph style). Possibly move the other eventhandlers too, if that is possible.'>
	self assert: self context isNotNil.
	self aptitude
		add: (BrGlamorousWithContextMenuAptitude content: [ self contextMenu ]).
	self addEventHandler: (HypernodePullHandler for: self).
	self addEventHandler: HyperlinkDragHandler new.
	self
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					evt consumed: true.
					self phlow spawnObject: self node ])
]

{ #category : #accessing }
HypernodeElement >> initialize [
	<todo:
		'What should be the basic layout? BlFrameLayout or BlLinearLayout vertical? Should this also be part of the configurable look?'>
	super initialize.

	"NB: the node context will be set by context: when created via HypernodeElement class>>#forContext:"
	self
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].

	"The aptitide will be updated when the context is set."
	self aptitude: DefaultGraphStyle new nodeAptitude.
	self updateNode.
	self graph beNode.
	"self handleEvents."
	^ self
]

{ #category : #accessing }
HypernodeElement >> node [
	^ self context node
]

{ #category : #accessing }
HypernodeElement >> node: aNode [
	self deprecated: 'Use context: instead'.
	nodeContext := aNode.
	self graph model: aNode
]

{ #category : #accessing }
HypernodeElement >> subscribe [
	<todo: 'subscribe to my node''s update announcements.
	for example, change my border when I start to contain subnodes;
	change my text label when my name changes ...'>
	
	"self node announcer when: XYZ do: [] for: self"
	
]

{ #category : #accessing }
HypernodeElement >> updateNode [

	<todo: 'To be wired into announcements!'>
	
	"card name = card defaultName
		ifTrue: [ self beEditable ]
		ifFalse: [ self beText ].
	self graph model: card"
	
]
