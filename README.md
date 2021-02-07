# Maker-Faire-Orlando-iOS

iOS Application for Maker Faire Orlando attendees

## Pandemic

There was no traditional Maker Faire Orlando in 2020. Still hopes for one in 2021.

## Overhaul

I'm really considering totally rebuilding this in Swift UI in the first half of 2021. 
That would obsolete a good bit of the below todo list.

## Todo for 2021

[ ] Avoid a world-wide pandemic

[ ] Event JSON processing should better handle date order

[ ] Event segmented control should get dates from events JSON

[ ] Async lazy-loading of maker images should cancel async task on cell reuse

[ ] Async lazy-loading of event images should cancel async task on cell reuse

[ ] JSON and image caching could use a more stock solution

[ ] A lot of general fragility in error handling and optional unwrapping

[ ] Poor handling if site is offline, DDOSed, or unreachable

[ ] Would be good to hit a backup site if primary is offline

[ ] Really should ship with an initial set of cached JSON and images

[ ] The detail view layouts are a little rough and should collapse labels when they're empty

[ ] Detail view should use all the JSON fields we have - URL?

[ ] Might be good to be able to segment off or indicate which makers are combat robot teams

[ ] The detail view layouts should handle images better - either resize imageview to match or crop images

[ ] In detail view it's not entirely clear that "Spirit Building" is a location

[ ] Maker collection view cell sizes could be better on different size classes

[ ] Maker collection view cell text could look better

[ ] Maker collection view cell caption background color could come from image like Android does

[ ] Would be good to be able to swipe between tabs (Makers, Events, Map)

[ ] Would be good to be able to swipe back from detail views

[ ] Red color is not consistent throughout app

[ ] Map updating and caching logic is really rough

[ ] Want a way to refresh map but pull-to-refresh in that scrollview is rough UX

[ ] Initial load of map view lags 

[ ] Would be nice if past events were greyed out or something

[ ] Refresh view shouldn't be dismissed immediately but wait for success or failure

[ ] Map should be centered in view esp. in landscape

[ ] Margins on map view are wasting a little space

[ ] Is there any better way to handle the map pan/zoom?



## Copyright and license

The copyright status and license of the code is a little unclear.

The images (icon, map, launch screen badge, etc.) are licensed trademarks from Maker Media. 

