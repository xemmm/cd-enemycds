# cd-enemycds

Edit of cdframes by shirsig for WoW Client 1.12.1

**Ever want to remove the local player cooldowns on cdframes? Well good thing I did it for you!**

All credit to shirsig, original git can be found here (https://github.com/shirsig/cdframes)

![image](https://user-images.githubusercontent.com/105894676/187053845-624acd5d-cb89-4dfb-a527-27232f372e6e.png)
![image](https://user-images.githubusercontent.com/105894676/187054001-8356bd60-31d3-44b8-a974-d707825e431e.png)


**COMMANDS**

**/cdframes used** (shows player cooldowns only for the spells used, ignoring shared cooldowns, default on)

**/cdframes frame** name code (Adds a new frame with name name. code is a lua expression which must evaluate to the name of the unit who's cooldowns the frame should show. Without code the frame is removed and without name the existing frames are listed)

**Some examples for custom frames you might want to add:**

**/cdframes targettarget UnitName'targettarget'** (adds a frame for the target's target)

**/cdframes frame focus FocusCore and FocusCore:GetName()** (adds a frame for the focus of FocusFrame)

**/cdframes frame focus pfUI and pfUI.uf and pfUI.uf.focus and pfUI.uf.focus:IsShown() and pfUI.uf.focus.unitname and gsub(pfUI.uf.focus.unitname, '^%l', strupper)** (adds a frame for the focus of pfUI)

**/cdframes frame party1 UnitName'party1'** (adds a frame for the first party member)


**The following commands by default are applied to all frames. To apply them to specific frames just use those as the first parameters (e.g., /cdframes player target unlock to unlock the frames player and target).**

**/cdframes lock** (locks frames, default off)

**/cdframes unlock** (unlocks frames)

**/cdframes size x** (maximum number of timers per frame, x between 1 and 100, default 15)

**/cdframes line x** (maximum number of timers per line, x between 1 and 100, default 8)

**/cdframes scale x** (x between 0.5 and 2, default 1)

**/cdframes spacing x** (x between 0 and 1, default 0, represents fraction of icon size)

**/cdframes skin name** (changes the style. available options for name: darion, blizzard, zoomed, elvui, modui)

**/cdframes blink x** (starts blinking at x seconds, default 0)

**/cdframes shadow** (cooldown shadow animation, default off)

**/cdframes count** (toggles the countdown, default on)

**/cdframes order attribute** (changes the order of cooldowns. available options for attribute: remaining, start)

**/cdframes ignore add list** (list is a comma separated list of skill names to ignore, no spaces except within the name, case insensitive. example: mortal strike,blink,shadow word: pain)

**/cdframes ignore remove** list

**/cdframes ignore** (shows the current ignore lists)

When unlocked you can drag the frame with the left button or rotate it by **<Left Click>**. **<Right Click>** has the same effect as **/cdframes** frame **lock.**
