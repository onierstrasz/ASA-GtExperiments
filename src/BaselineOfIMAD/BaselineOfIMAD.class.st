Class {
	#name : #BaselineOfIMAD,
	#superclass : #BaselineOf,
	#category : #BaselineOfIMAD
}

{ #category : #baselines }
BaselineOfIMAD >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			"package: #'ASA-GtExperiments' ;"
			package: #'IMAD-FSA' ;
			package: #'IMAD-Cards'
			].

]