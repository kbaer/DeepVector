DeepVector is an exploration of the Apple Vision Pro volumetric view creation. The first computer graphics programs I made when I was in High School were 2D vector graphics on Tektronix 2010 terminals. This is an homage back to the look and feel
of those early apps, but pulling it into 3D and being able to walk around it. This also gave me a reason to explore SwiftUI animation, and how to stagger animation. This app does not use 3D models, I started another app that does and uses an 
immersive view. I plan to apply what I learned here to the other app. 

This app draws a 2D triangle path, iterating it with a rotation, set with a control panel with a slider. 
There's a button to toggle animation, which animates between negative and positive rotation values.
The Reset button hides and shows the triangles, using the animated sequence first showing a white triangle with a glow, then fading to green with no glow. This intended to emulate the Tektronix vector graphics phosphore screen.

This is still a work in progress, and I'm still getting used to SwiftUI after being a Swift dev for the last decade or so. Suggestions welcome.

-Ken Baer.
