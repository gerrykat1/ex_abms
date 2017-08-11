breed [ non-native_US_students non-native_US_student ]   ;; Establish breed of non-native and/or immigrant students (nnis), directed because they will only be asked of
breed [ native_US_students native_US_student ] ;; Establish breed of all other agents, who will be asking nnis
globals [mean-belongingness]
Turtles-own [ my-belongingness             ;; Tracks how much students feel like they belong
  nr_of_times_asked
]

To setup
  clear-all
  ask patches [ set pcolor gray ]    ;; Set background to make it easier to see
  set-default-shape turtles "person" ;; Set shape to person, logical

  create-Non-native_US_students number_of_Non-native_US_students ;; create the students
  [
     setxy random-xcor random-ycor   ;; Distribute randomly
     set size 3                     ;; Make them easier to see
     Set color Green                 ;; Differentiate color of_Non-native_US_students from that of Native_US_students
     set my-belongingness 100        ;; arbitrary
  ]
  create-native_US_students number_of_Native_US_students ;; create the other people
  [
     setxy random-xcor random-ycor   ;; Distribute randomly
     set size 3                      ;; Make them easier to see
     Set color Blue                 ;; Differentiate color from that of nni students
     set my-belongingness 100        ;; Every new student begins with high level of feeling of belonging - they were accepted here, and figured out how to pay for it!
  ]
  ask turtles [
   ;; change the color of students who are bias busting to yellow
    if random-float 100 < %_of_students_Bias_Busting [ set color yellow ]
  ]
  Reset-ticks
end

To go
    if ticks = 20 [ stop ] ;; Stop the model when belongingness gets to an arbitrary level ]

     Ask turtles
     [
     move
        ;; If the student is not a Bias Buster (yellow)
         if  (color != yellow )  [ ask one-of native_US_students [
             ;; ask one of the other people to link with nearby one of
             ;; the non-native/ immigrant students they have not already linked to
             ;; create a local variable that reports, contains, the agentset of all the turtles connected by direct links out, to the breed native_US_students
        let nniconnections-i-have out-link-neighbors
        ;;    print "****"
        ;;    print [who] of nniconnections-i-have
        ;;   Create a local variable of non-native_US_students within a radius of patches who are not members of the agentset created above
       let potential-nniconnections (non-native_US_students in-radius 3) with [ not member? self nniconnections-i-have ]

        if any? potential-nniconnections [
          let tgt-nniconnection one-of potential-nniconnections

          ifelse random-float 100 < Probability_ask-Where_are_you_really_from?
          ;; ifelse random-float 100 < Probability_ask-When_are_you_going_to_get_married?
                      ;; alternative common question
           [ create-link-to tgt-nniconnection ]

           [set nr_of_times_asked nr_of_times_asked + 1 ]
        ;;   print "****"
          ;; print who
         ;;    print nr_of_times_asked
             ask links [ set color red ]
                 ]]]]
     ask non-native_US_students [
           ;; Create local variable that is the number of links going into non-native_US_student
       let nr_of_inlinks count my-in-links

          ;; belongingness increment down if non-native-US is asked WAYRF
        set my-belongingness ( my-belongingness - (nr_of_inlinks) )
          ;; belongingness increment up if non-native-US is not asked WAYRF in x cycles
        if ( nr_of_times_asked < 3 ) [ set my-belongingness (my-belongingness + 1)]
        ;; Set size of icon to correlate to level of belongingness
       if (color != yellow ) and my-belongingness <  70 [ set size 2 ]
        ;; if student is a bias buster they understand the dynamic, are not as impacted
       if  my-belongingness < 2 [ set my-belongingness 2 ] ;; set floor for my-belongingness
               set mean-belongingness mean [my-belongingness] of non-native_US_students
     ]
    Tick

 end

 to move       ;; People move about at random
   rt random-float 360
   fd 2
   end
@#$#@#$#@
GRAPHICS-WINDOW
433
26
1053
647
-1
-1
12.0
1
10
1
1
1
0
1
1
1
-25
25
-25
25
0
0
1
days
30.0

SLIDER
20
22
253
55
number_of_Non-native_US_students
number_of_Non-native_US_students
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
20
79
348
112
number_of_Native_US_students
number_of_Native_US_students
0
500
200.0
1
1
NIL
HORIZONTAL

BUTTON
31
257
97
290
NIL
Setup
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
222
250
345
294
NIL
Go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
22
135
415
168
Probability_ask-Where_are_you_really_from?
Probability_ask-Where_are_you_really_from?
0
100
16.0
1
1
NIL
HORIZONTAL

PLOT
41
331
380
499
 Feeling of Belonging of Non-native US Students
Days
Belongingness
0.0
14.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -13840069 true "" "plot mean [my-belongingness] of non-native_US_students"

SLIDER
23
188
249
221
%_of_students_Bias_Busting
%_of_students_Bias_Busting
0
100
0.0
1
1
NIL
HORIZONTAL

BUTTON
117
257
203
290
Go 1 day
Go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

This model explores the effects on non-native English speaking and/or immigrant students, of being asked "Where are you really from?" multiple times. An example scenario in a bias busting workshop (scs4all.cs.cmu.edu/biasbusters/) is meeting someone new, asking "where are you from?", and if they look or sound like they may be from outside the US, but answer something like "Rhode Island", often are then asked "Where are you really from?".

From the article "Who Belongs in Tech?" (https://medium.com/inclusion-insights/who-belongs-in-tech-9ef3a8fdd3#.n3rnn4mbe)    "When people enter a new environment, like when they start college or a new job, they often wonder whether or not they’ll belong. Research shows that this concern can be especially pronounced for members of demographic groups that are underrepresented in that environment. Because of this uncertainty, people from underrepresented groups are more likely to be on the lookout for cues to determine whether or not they belong.

Additional research (http://www.psychologicalscience.org/JOURNALS/CD/17_6_INPRESS/COHEN.PDF) shows that "subtle events that confirm a lack of social connectedness have disproportionately large impacts" (on members of minority groups)..."they may do so even in the absence of prejudice, fears of confirming the stereotype, or an anticipated intellectual evaluation....results suggest that belonging uncertainty need not involve a fear of being stereotyped or subjected to racial bias. Rather it can take the form of a broader concern that "people in my group do not belong."

CNN published an article on this phenomena and is collecting input, so it may be possible to link with them to be in lies the results and correlate them to a model of this type.

## HOW IT WORKS

The SETUP procedure creates a population of non-native English speaking and/or immigrant students (non-native_US_students), whose icons are green, and other people on campus (native_US_students) icons are blue, all randomly distributed.
A percentage of the students can be designated as Bias Busters (have attended a bias busting workshop), as input by the user on the %_of_students_Bias_Busting slider. This turns their icon yellow, and if they are involved in an interaction, the native US students are questioned and/or tactfully educated if they ask "Where are you really from?". According to studies, this relieves pressure on the non-native US student, and ideally helps the native US student realize their question may have a negative impact, even if it was not intended to.

Native_US_students ask non-native_US_students "where are you really from?" with probability set by the user with the Probability_ask_Where_are_you_really_from slider.

At each time step an agent–agent interaction takes place; when a non-native speaking and/or immigrant is asked "where are you really from?, you can see a red arrow into the non-native English speaking students, and their "belongingness" counters are decremented. Their frustration increases, but since that is also directly correlated to the number of times the student is asked "where are you really from?", will not include a separate indicator of this.

Plot shows the mean of the value of my-belongingness of non-native_US_students, as the feeling of belonging of Non-native US Students.

## HOW TO USE IT

The number_of_Non-native_US_students slider controls the number of non-native English speaking and/or immigrant students in the world. The number_of_Native_US_students slider controls the number of other people (all other agents).

The Probability_ask_Where_are_you_really_from slider controls the probability Native_US_students will ask Non-native_US_students that they have not met before, "Where are you really from?".

To use the model, set these parameters and then press SETUP.
Pressing the GO button causes all of the agents to move randomly around the environment each tick step. Native_US_students check to see if there is a Non-native_US_student nearby, that they have not met. If there is, they create a link into that agent.

The Belongingness parameter of the Non-native_US_student is decremented each time they are asked "where are you really from?"

The model stops at an arbitrary time, since after a certain period students are unlikely to meet new people at the same rate.

One might run the model with the %_of_students_Bias_Busting slider set to zero and show the results, then increase the %_of_students_Bias_Busting slider to represent how many people in that environment have taken the Bias Buster class, so students can see the difference.

This model has not yet been validated with empirical data, so the initial purpose is to visualize what the impact of disrupting this type of bias might be. Ideally, empirical studies could be found, or conducted, to validate results in the real world, and new studies/surveys could be conducted to confirm what really happens in similar real world interactions.

## THINGS TO NOTICE

If one sets the %_of_students_Bias_Busting slider set to zero, then sets the %_of_students_Bias_Busting slider to 50%, you should see a measurable increase in the belongingness.

## VALIDATION
Initial face-validation John Miller, Amy Quispe, October 20, 2016
Additional validation and calibration is required.

## CREDITS AND REFERENCES
NetLogo is free, open source software under the GPL (GNU General Public License), version 2.
Wilensky, U. 1999. NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University. Evanston, IL.
Thanks and appreciation to Prof.s Bill Rand and John H. Miller for their help and support in creating this model.
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
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment1" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>mean-belongingness</metric>
    <enumeratedValueSet variable="Probability_ask-Where_are_you_really_from?">
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number_of_Non-native_US_students">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%_of_students_Bias_Busting">
      <value value="0"/>
      <value value="10"/>
      <value value="20"/>
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number_of_Native_US_students">
      <value value="200"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
