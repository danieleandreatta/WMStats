#!/usr/bin/gst -gf

|pages t0 t1 fin|

t0 := Time primMillisecondClock.

fin := FileStream open: (Smalltalk getArgv: 1) mode: 'rb'.

pages := SortedCollection new.
pages setSortBlock: [ :x :y | (x at: 2) > (y at: 2) ].

[fin atEnd] whileFalse: [ |line words|
    line := fin nextLine.
    words := line tokenize: ' '.
    ((words at: 1) = 'en') ifTrue: [
        ((words at: 3) asNumber) > 500 ifTrue: [ |t|
            t := OrderedCollection new.
            t add: (words at: 2); add: ((words at: 3) asNumber).
            pages add: t.
        ]
    ]
].

t1 := Time primMillisecondClock.

('Query took %1 seconds' bindWith: (t1-t0*0.001)) displayNl.

n := (10 < pages size) ifTrue: [10] ifFalse: [pages size].

1 to: n do: [ :i |
    ('%1 (%2)' bindWithArguments: (pages at: i)) displayNl.
].
