#!/usr/bin/gst -gf

Object subclass: #Page.
Page instanceVariableNames: 'name hits'.
Page extend [
    name: n hits: h [ name := n. hits := h. ]
    asString [ ^'%1 (%2)' bindWith: name with: hits. ]
    printOn: stream [ stream nextPutAll: (self asString). ]
    hits [ ^hits. ]
].

Object subclass: #Timer.
Timer instanceVariableNames: 't0 t1'.
Timer extend [
    start [ t0 := Time millisecondClock. ^self ]
    stop [ t1 := Time millisecondClock. ^self ]
    asString [ ^('Query took %1 seconds' bindWith: (t1 - t0 * 0.001)) ]
    printOn: stream [ stream nextPutAll: (self asString) ]
].

Object subclass: #PageList.
PageList instanceVariableNames: 'pages'.
PageList extend [
    setup [
        pages := SortedCollection sortBlock: [ :x :y | (x hits) > (y hits) ]
    ]
    tryAdd: line [
        |words hits|
        (line copyFrom: 1 to: 3) = 'en ' ifTrue: [
            words := line substrings.
            hits := (words at: 3) asNumber.
            hits > 500 ifTrue: [
                pages add: (Page new name: (words at: 2) hits: hits).
            ]
        ]
    ]
    at: i [
        ^pages at: i
    ]
    size [
        ^pages size
    ]
].

|timer pages n fin|

timer := Timer new start.

fin := FileStream open: (Smalltalk getArgv: 1) mode: 'rb'.

pages := PageList new setup.

[fin atEnd] whileFalse: [ pages tryAdd: (fin nextLine) ].

timer stop displayNl.

n := (10 < pages size) ifTrue: [10] ifFalse: [pages size].

1 to: n do: [ :i |
    (pages at: i) displayNl.
].
