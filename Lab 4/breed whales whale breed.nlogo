breed [whales whale]
breed [boats boat]
breed [sensors sensor]
boats-own [mailbox        ;;; List of messages
           my-whales      ;;; List of [whale, ticks+]
           ratio-sensor   ;;; Value of the sensor ratio
           initiator-cfps ;;; List of [id [whale ticks+]]
           follower-cfps  ;;; List of IDs
           finished-cfps  ;;; List of IDs
           succesful-cfps ;;; List of [whale number]
           failed-cfps ]  ;;; List of [whale ticks+]
whales-own [ my-boat ]   ;;; The boat currently monitoring it/nobody
globals [min-who-whales  ;;; Just for nice ploting proposes
         id ]            ;;; For using unique IDs

to setup
  clear-all
  reset-ticks
  set id 0
  set-default-shape boats "boat"
  setup-boats
  set-default-shape whales "fish"
  setup-whales
  setup-plot-whales
end

to setup-boats
  set-default-shape sensors "transparent circle"
  let allowed-colors remove blue base-colors
  create-boats num-boats [
    setxy random-xcor random-ycor
    set size 2
    set color one-of allowed-colors
    set ratio-sensor (random 10 + 10)
    set mailbox []
    set my-whales []
    set initiator-cfps []
    set follower-cfps []
    set failed-cfps []
    set succesful-cfps []
    set finished-cfps []
    hatch-sensors 1 [
      set size 2 * [ratio-sensor] of myself
      create-link-from myself [tie hide-link]
    ]
  ]
end

to setup-whales
  create-whales num-whales [
    set hidden? true
    ;;; At the beginning a whale is monitored by a boat
    set my-boat one-of boats
    let rs [ratio-sensor] of my-boat - 5
    set xcor [xcor] of my-boat + random rs - random rs
    set ycor [ycor] of my-boat + random rs - random rs
    set color [color] of my-boat
    set hidden? false
    ask my-boat [
      set my-whales lput (list myself ticks) my-whales
    ]
  ]
end

to go
  ;if ticks = 300 [save-data-of-whales-to-file-and-stop]
  move
  acting-as-initiator
  acting-as-follower
  tick
  update-plot-whales
end

to acting-as-initiator
   ;; Code to complete
   ;; Code to complete
   ;; Code to complete
end

to acting-as-follower
   ;; Code to complete
   ;; Code to complete
   ;; Code to complete
end

to move
  ask whales [
    if random 100 < 10 [rt random 180]
    fd 0.7
  ]
  ask boats [
    if random 100 < 10 [rt random 360]
    fd 0.1
  ]
end


;;; This includes calling to initiate-new-cfps
;;;    and to introduce a new unique ID in the initiator-cfps list
;;;    obtained by using the [who] of the cfp msg
to revise-my-whales
  ;;; Calculate if any of my whales are out of my scope
  let whales-out filter
            [x -> distance first x > ratio-sensor] my-whales

  if not empty? whales-out [
    set my-whales filter [x -> not member? x whales-out] my-whales
    foreach whales-out [
      x -> ask first x [
              set color blue
              set my-boat nobody
           ]
           ;;; At ticks this whale is out of my scope
           initiate-new-cfps lput ticks x
    ]
  ]
  ;;; Start a new cfp for the whales whose previous cfps had failed
  foreach failed-cfps [
    x -> initiate-new-cfps x
  ]
end

;;:
;;; Code to deal with contract-net protocol
;;;
;;; For the role of initiator in contract-net

;;;   _x: A list with the whale that I was monitoring, but now is out
;;;          of my scope, with its related ticks
to initiate-new-cfps [ _x ]
   ;; Code to complete
   ;; Code to complete
   ;; Code to complete
end


to receive-responses-to-proposals-cfps
  let finishing-cfps []
  foreach follower-cfps [
    _id ->
           let lmsgs get-lmsgs-key mailbox "conversation-id" _id
           if not empty? lmsgs [
              let msg one-of lmsgs
              set mailbox filter [m -> not member? m lmsgs] mailbox
              ;;; Type of message:accept-proposal or reject-proposal
              if get-value-msg msg "performative" = "accept-proposal" [
                 ;;; add whale to my-whales
                 ;;; The accept-proposal message contains a list
                 ;;;   with [whale (dataStart, dataEnd)+]
                 let new-whale-info lput ticks get-value-msg msg "content"
                 set my-whales lput new-whale-info my-whales
                 ask first new-whale-info [
                     set color [color] of myself
                     set my-boat myself
                 ]
                 show new-whale-info
              ]

              ;;; This conversation must end for a-p and r-p messages
              set finishing-cfps fput _id finishing-cfps
           ]
  ]
  ;;; Remove conversation-ids from followers-cfps
  set follower-cfps filter
               [_id -> not member? _id finishing-cfps] follower-cfps
end

;;;;
;;;; Code to deal with ACL messages
;;;;

to-report create-message [performative]
;;;
;;; Your code done in practica 1 here
;;;
end

to-report set-value-msg [msg key value]
;;;
;;; Your code done in practica 1 here
;;;
end

to-report get-value-msg [msg key]
;;;
;;; Your code done in practica 1 here
;;;
end

to send-message [msg]
;;;
;;; Your code done in practica 1 here
;;;
end

to-report count-mailbox-id [_id]
;;;
;;; Your code done in practica 1 here
;;;
end

to-report get-lmsgs-key [lmsgs key value]
;;;
;;; Your code done in practica 1 here
;;;
end

to-report get-min-msg [lmsgs]
;;;
;;; Your code done in practica 1 here
;;;
end

;;;
;;; Code to deal with generating new unique IDs
;;;

to-report increment-and-get-id
  set id id + 1
  report id
end

;;;
;;; Code to save whales' data onto a file
;;;
to save-data-of-whales-to-file-and-stop
   ;; Code to complete
   ;; Code to complete
   ;; Code to complete
end

;;;
;;; Ploting procedures
;;;

to setup-plot-whales
  set min-who-whales [who] of min-one-of whales [who] - 1
  ask boats [
    create-temporary-plot-pen (word color)
    set-plot-pen-color color
    set-plot-pen-mode 2
  ]
  create-temporary-plot-pen (word blue)
  set-plot-pen-color white
  set-plot-pen-mode 2
end

to update-plot-whales
  ask whales [
    set-current-plot-pen (word color)
    plotxy ticks (who - min-who-whales) * 2
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
207
32
1528
704
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-50
50
-25
25
1
1
1
ticks
30.0

SLIDER
15
51
187
84
num-boats
num-boats
1
15
13.0
1
1
NIL
HORIZONTAL

SLIDER
16
95
188
128
num-whales
num-whales
1
10
6.0
1
1
NIL
HORIZONTAL

BUTTON
31
136
94
169
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
109
136
167
169
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
9
176
150
221
maximum failed cfps
max [length failed-cfps] of boats
17
1
11

MONITOR
107
176
189
221
num-agents
count turtles
17
1
11

MONITOR
32
225
159
270
Whales without boat
count whales with [my-boat = nobody]
17
1
11

PLOT
1
275
194
451
Contract-net messages
Ticks
Total number
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"msgs" 1.0 0 -14439633 true "" "plot mean [length mailbox] of boats"
"cfps" 1.0 0 -14454117 true "" "plot mean [length initiator-cfps] of boats"
"failed cfps" 1.0 0 -5825686 true "" "plot mean [length failed-cfps] of boats"

PLOT
2
458
206
603
Monitoring whales
Ticks
Whales
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"nobody" 1.0 0 -13791810 true "" ""

@#$#@#$#@
## WHAT IS IT?

It is a proof of concept for the Contract-net protocol. There is a ready to be explored ocean area where multiple scientific boats try to monitorize whales routes. Each boat can observe (showed in the view as circles of the same color of the boat) a limited area of the ocean. Both boats and whales are continuously moving.

## HOW IT WORKS

At the beginning of the simulation, each boat manages some whales. Whenever any whale is out of the scope of its related boat, the boat starts a Contract-net round asking for proposals to monitorize that whale to the other boats. Then, each of these other boats calculates whether this whale is in its observed area. If it is, then responses with a proposal message containing its distance to the whale. if the whale is not in its observed area then it responses with a reject message. Once received all messages from the potential collaborator boats to the boat asking for help, that boat selects the proposal boat with the minimum distance to the whale and send to this winning boat a message asking to observe that whale. If all the messages received at the asking boat are rejects then the asking boat looks for again if this lost whale is in its observing area (remember that boats and whales are continuously moving). If it is again in its observed area, the boat continues monitoring it. If it is out of its observed area yet, it starts a new Contract-net asking for help. This process occurs dynamically for all boats and all whales at every tick.

## HOW TO USE IT

There are sliders to select the number of whales and boats.
There is one graph showing the total number of Contract-net rounds being performed versus the ones that finish with a winning boat.
There is another graph that shows for each whale in every tick if it is currently being monitored (by showing a line whose color is the same as the color of the boat that is monitoring it) When a whale is not being currently monitored there is no line for those ticks of execution.
There are also monitors showing the total number of agents in execution, the total number of messages in execution and the total number of whales without a related observed boat.

## THINGS TO NOTICE

In this model, boats, sensors, whales and messages are turtles. There is a lot of agentsets and lists of agents that are used. Try to understand, by the comments in the code section, which are their meanings and how to modify them.
Each boat stores for each whale the whole history of its observations (pairs of ticks meaning the first time it was observed (maybe again observed after the whale was out of the scope for some time) and the last time it was observed (because it was out of the scope of its related observed boat).


## THINGS TO TRY

Do executions with a very few boats and a very few whales to observe the way the model works. Then, increment that number of boats and whales. It also observes how the number of messages and the number of agents behave during the simulation.
 

## EXTENDING THE MODEL

Whenever a boat wins a Contract-net round, it must add a new whale to the whales that it is currently managed. But the Contract-net protocol defines that when this boat finishes this task (because the whale is now out of its scope) it should send a message to the boat at which this whale belonged before the Contract-net had started telling that.

## NETLOGO FEATURES

The observed area in each turtle boat is defined as a sensor turtle. Both turtles are tied together by a hidden link so, the movement of the boat implies the automatic movement of the sensor.

## RELATED MODELS

There is no other model in the Library of Models of Netlogo similar to this.

## CREDITS AND REFERENCES

Defined and programmed by Luis Amable Garcia Fernandez for the course "Multiagent Systems". The students must complete the code of the Contract-net protocol. This course is part of the Master in Intelligent Systems at the Jaume I University of Spain.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

circle 2 fine
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 3 3 294

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

transparent circle
true
0
Circle -7500403 false true 0 0 300

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
