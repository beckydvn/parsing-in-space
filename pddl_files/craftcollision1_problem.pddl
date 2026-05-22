(define (problem craftcollision1) (:domain canadarm3-real)
(:objects 
    debris1 - debris
    debris2 - debris
    port1 - port
    
    ;s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 - speed ;speeds trackable objects can move at
    ;cp1 cp2 cp3 cp4 cp5 cp6 cp7 cp8 cp9 cp10 cp11 cp12 cp13 cp14 cp15 cp16 cp17 cp18 cp19 cp20 cp21 cp22 cp23 cp24 cp25 cp26 cp27 cp28 cp29 cp30 cp31 cp32 cp33 cp34 cp35 cp36 cp37 cp38 cp39 cp40 cp41 cp42 cp43 cp44 cp45 cp46 cp47 cp48 - spawn_coord
    ;cp1 cp2 cp3 cp4 cp5 cp6 cp7 cp8 cp9 cp10 cp11 cp12 cp13 cp14 cp15 cp16 cp17 cp18 cp19 cp20 cp21 cp22 cp23 cp24 - spawn_coord
    s1 s2 s3 s4 s5 - speed
    ;s1 - speed
    ;cp1 cp2 cp3 cp4 cp5 cp6 cp7 cp8 cp9 cp10 - spawn_coord
    cp1 cp2 cp3 cp4 - spawn_coord
)

(:init
    ;initialize function values
    (= (collision-distance) 7) ; min distance the craft can be before a collision is a detected
    (= (sensor-range) 20) ; how far the sensor can see
    (= (arm-speed) 1) ; how fast the arm should be moving

    ;arm coords
    (= (x-arm) 200)
    (= (y-arm) 200)

    ;velocity of the arm
    (= (vx-arm) 0) ; should be 0 -- just assume it's stationary -- everything should be measured relative to the arm... obj velocity more needed to test for collisions
    (= (vy-arm) 0)
    
    ;--------SCENE OBJECTS ----------

    ;pos of debris1
    (= (x-obj debris1) 0)
    (= (y-obj debris1) 0) ;put at unspawned obj point

    ;velocity of debris1
    (= (vx-obj debris1) 0)
    (= (vy-obj debris1) 0)

    ;pos of debris2
    (= (x-obj debris2) 0)
    (= (y-obj debris2) 0) ;put at unspawned obj point

    ;velocity of debris2
    (= (vx-obj debris2) 0)
    (= (vy-obj debris2) 0)

    ;port coords
    (= (x-obj port1) 205)
    (= (y-obj port1) 205)

    ;-----END OF SCENE OBJECTS------------

    ;unspawn object point
    (= (x-unspawned) 0) ;coordinates for where objects should be when they're not currently active
    (= (y-unspawned) 0)

    (= (orbit-clock) 5) ;will let us use a toggle to go between T/F for  in-sun
    (= (orbit-clock-counter) 5) ;same as orbit clock max time (hack)

    (= (sensor-repair-clock) 20) ;sensor can be repaired after a certain amount of time
    (= (sensor-repair-clock) 20) ;same as sensor repair clock max time (hack)

    (= (battery-level) 1000) ;how much battery the arm has currently (affected by charging and draining)
    (= (battery-drain-rate) 1) ;rate at which the battery drains when in shade
    (= (battery-charge-rate) 2) ;rate at which the battery charges when in sun
    (= (full-battery-capacity) 1000) ;how much charge the battery can hold (max capacity)

    (= (num-collisions) 0)

    (port-free port1)
    (grasp-free)
    (in-sun)
    (sensor-functional)

    ;radius of grid space is 100
    (= (grid-range) 30)
    (= (x-center-point) 200)
    (= (y-center-point) 200)

    ;test 2
    ; (= (x-spawn cp1) 300.0)
    ; (= (y-spawn cp1) 200.0)
    ; (= (x-spawn cp2) 100.0)
    ; (= (y-spawn cp2) 200.0)

    ;test 4 w rad 30
    (= (x-spawn cp1) 230.0)
    (= (y-spawn cp1) 200.0)
    (= (x-spawn cp2) 200.0)
    (= (y-spawn cp2) 230.0)
    (= (x-spawn cp3) 170.0)
    (= (y-spawn cp3) 200.0)
    (= (x-spawn cp4) 200.0)
    (= (y-spawn cp4) 170.0)

    ; test 10
    ; (= (x-spawn cp1) 230.0)
    ; (= (y-spawn cp1) 200.0)
    ; (= (x-spawn cp2) 224.27)
    ; (= (y-spawn cp2) 217.63)
    ; (= (x-spawn cp3) 209.27)
    ; (= (y-spawn cp3) 228.53)
    ; (= (x-spawn cp4) 190.73)
    ; (= (y-spawn cp4) 228.53)
    ; (= (x-spawn cp5) 175.73)
    ; (= (y-spawn cp5) 217.63)
    ; (= (x-spawn cp6) 170.0)
    ; (= (y-spawn cp6) 200.0)
    ; (= (x-spawn cp7) 175.73)
    ; (= (y-spawn cp7) 182.37)
    ; (= (x-spawn cp8) 190.73)
    ; (= (y-spawn cp8) 171.47)
    ; (= (x-spawn cp9) 209.27)
    ; (= (y-spawn cp9) 171.47)
    ; (= (x-spawn cp10) 224.27)
    ; (= (y-spawn cp10) 182.37)

    ;test 48
    ; (= (x-spawn cp1) 300.0)
    ; (= (y-spawn cp1) 200.0)
    ; (= (x-spawn cp2) 299.14)
    ; (= (y-spawn cp2) 213.05)
    ; (= (x-spawn cp3) 296.59)
    ; (= (y-spawn cp3) 225.88)
    ; (= (x-spawn cp4) 292.39)
    ; (= (y-spawn cp4) 238.27)
    ; (= (x-spawn cp5) 286.6)
    ; (= (y-spawn cp5) 250.0)
    ; (= (x-spawn cp6) 279.34)
    ; (= (y-spawn cp6) 260.88)
    ; (= (x-spawn cp7) 270.71)
    ; (= (y-spawn cp7) 270.71)
    ; (= (x-spawn cp8) 260.88)
    ; (= (y-spawn cp8) 279.34)
    ; (= (x-spawn cp9) 250.0)
    ; (= (y-spawn cp9) 286.6)
    ; (= (x-spawn cp10) 238.27)
    ; (= (y-spawn cp10) 292.39)
    ; (= (x-spawn cp11) 225.88)
    ; (= (y-spawn cp11) 296.59)
    ; (= (x-spawn cp12) 213.05)
    ; (= (y-spawn cp12) 299.14)
    ; (= (x-spawn cp13) 200.0)
    ; (= (y-spawn cp13) 300.0)
    ; (= (x-spawn cp14) 186.95)
    ; (= (y-spawn cp14) 299.14)
    ; (= (x-spawn cp15) 174.12)
    ; (= (y-spawn cp15) 296.59)
    ; (= (x-spawn cp16) 161.73)
    ; (= (y-spawn cp16) 292.39)
    ; (= (x-spawn cp17) 150.0)
    ; (= (y-spawn cp17) 286.6)
    ; (= (x-spawn cp18) 139.12)
    ; (= (y-spawn cp18) 279.34)
    ; (= (x-spawn cp19) 129.29)
    ; (= (y-spawn cp19) 270.71)
    ; (= (x-spawn cp20) 120.66)
    ; (= (y-spawn cp20) 260.88)
    ; (= (x-spawn cp21) 113.4)
    ; (= (y-spawn cp21) 250.0)
    ; (= (x-spawn cp22) 107.61)
    ; (= (y-spawn cp22) 238.27)
    ; (= (x-spawn cp23) 103.41)
    ; (= (y-spawn cp23) 225.88)
    ; (= (x-spawn cp24) 100.86)
    ; (= (y-spawn cp24) 213.05)
    ; (= (x-spawn cp25) 100.0)
    ; (= (y-spawn cp25) 200.0)
    ; (= (x-spawn cp26) 100.86)
    ; (= (y-spawn cp26) 186.95)
    ; (= (x-spawn cp27) 103.41)
    ; (= (y-spawn cp27) 174.12)
    ; (= (x-spawn cp28) 107.61)
    ; (= (y-spawn cp28) 161.73)
    ; (= (x-spawn cp29) 113.4)
    ; (= (y-spawn cp29) 150.0)
    ; (= (x-spawn cp30) 120.66)
    ; (= (y-spawn cp30) 139.12)
    ; (= (x-spawn cp31) 129.29)
    ; (= (y-spawn cp31) 129.29)
    ; (= (x-spawn cp32) 139.12)
    ; (= (y-spawn cp32) 120.66)
    ; (= (x-spawn cp33) 150.0)
    ; (= (y-spawn cp33) 113.4)
    ; (= (x-spawn cp34) 161.73)
    ; (= (y-spawn cp34) 107.61)
    ; (= (x-spawn cp35) 174.12)
    ; (= (y-spawn cp35) 103.41)
    ; (= (x-spawn cp36) 186.95)
    ; (= (y-spawn cp36) 100.86)
    ; (= (x-spawn cp37) 200.0)
    ; (= (y-spawn cp37) 100.0)
    ; (= (x-spawn cp38) 213.05)
    ; (= (y-spawn cp38) 100.86)
    ; (= (x-spawn cp39) 225.88)
    ; (= (y-spawn cp39) 103.41)
    ; (= (x-spawn cp40) 238.27)
    ; (= (y-spawn cp40) 107.61)
    ; (= (x-spawn cp41) 250.0)
    ; (= (y-spawn cp41) 113.4)
    ; (= (x-spawn cp42) 260.88)
    ; (= (y-spawn cp42) 120.66)
    ; (= (x-spawn cp43) 270.71)
    ; (= (y-spawn cp43) 129.29)
    ; (= (x-spawn cp44) 279.34)
    ; (= (y-spawn cp44) 139.12)
    ; (= (x-spawn cp45) 286.6)
    ; (= (y-spawn cp45) 150.0)
    ; (= (x-spawn cp46) 292.39)
    ; (= (y-spawn cp46) 161.73)
    ; (= (x-spawn cp47) 296.59)
    ; (= (y-spawn cp47) 174.12)
    ; (= (x-spawn cp48) 299.14)
    ; (= (y-spawn cp48) 186.95)

    ;generated from python file based on radius (centered at (200, 200))
    ; (= (x-spawn cp1) 300.0)
    ; (= (y-spawn cp1) 200.0)
    ; (= (x-spawn cp2) 296.59)
    ; (= (y-spawn cp2) 225.88)
    ; (= (x-spawn cp3) 286.6)
    ; (= (y-spawn cp3) 250.0)
    ; (= (x-spawn cp4) 270.71)
    ; (= (y-spawn cp4) 270.71)
    ; (= (x-spawn cp5) 250.0)
    ; (= (y-spawn cp5) 286.6)
    ; (= (x-spawn cp6) 225.88)
    ; (= (y-spawn cp6) 296.59)
    ; (= (x-spawn cp7) 200.0)
    ; (= (y-spawn cp7) 300.0)
    ; (= (x-spawn cp8) 174.12)
    ; (= (y-spawn cp8) 296.59)
    ; (= (x-spawn cp9) 150.0)
    ; (= (y-spawn cp9) 286.6)
    ; (= (x-spawn cp10) 129.29)
    ; (= (y-spawn cp10) 270.71)
    ; (= (x-spawn cp11) 113.4)
    ; (= (y-spawn cp11) 250.0)
    ; (= (x-spawn cp12) 103.41)
    ; (= (y-spawn cp12) 225.88)
    ; (= (x-spawn cp13) 100.0)
    ; (= (y-spawn cp13) 200.0)
    ; (= (x-spawn cp14) 103.41)
    ; (= (y-spawn cp14) 174.12)
    ; (= (x-spawn cp15) 113.4)
    ; (= (y-spawn cp15) 150.0)
    ; (= (x-spawn cp16) 129.29)
    ; (= (y-spawn cp16) 129.29)
    ; (= (x-spawn cp17) 150.0)
    ; (= (y-spawn cp17) 113.4)
    ; (= (x-spawn cp18) 174.12)
    ; (= (y-spawn cp18) 103.41)
    ; (= (x-spawn cp19) 200.0)
    ; (= (y-spawn cp19) 100.0)
    ; (= (x-spawn cp20) 225.88)
    ; (= (y-spawn cp20) 103.41)
    ; (= (x-spawn cp21) 250.0)
    ; (= (y-spawn cp21) 113.4)
    ; (= (x-spawn cp22) 270.71)
    ; (= (y-spawn cp22) 129.29)
    ; (= (x-spawn cp23) 286.6)
    ; (= (y-spawn cp23) 150.0)
    ; (= (x-spawn cp24) 296.59)
    ; (= (y-spawn cp24) 174.12)

    ;speed val assignments
    (= (speed-value s1) 1)
    (= (speed-value s2) 2)
    (= (speed-value s3) 3)
    (= (speed-value s4) 4)
    (= (speed-value s5) 5)
    ; (= (speed-value s6) 6)
    ; (= (speed-value s7) 7)
    ; (= (speed-value s8) 8)
    ; (= (speed-value s9) 9)
    ; (= (speed-value s10) 10)
)

(:goal (and (failure-collision debris1) (failure-collision debris2)) ; should be "or"
)
)