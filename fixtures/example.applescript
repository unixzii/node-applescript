(*
 Get User Name
 
 This script uses UI element scripting to get the name for the
 current user.
 
 Copyright © 2013 Apple Inc.
 
 You may incorporate this Apple sample code into your program(s) without
 restriction.  This Apple sample code has been provided "AS IS" and the
 responsibility for its operation is yours.  You are not permitted to
 redistribute this Apple sample code as "Apple sample code" after having
 made changes.  If you're going to redistribute the code, we require
 that you make it clear that the code was descended from Apple sample
 code, but that you've made changes.
 *)
 
 tell application "System Preferences"
 activate
 set current pane to pane "com.apple.preferences.users"
 end tell
 
try
	tell application "System Events"
		tell tab group 1 of window "Users & Groups" of process "System Preferences"
			delay 2
			click radio button "Password"
			delay 2
			set theResult to value of text field "Full name:"
		end tell
	end tell
	activate me
	display dialog "Full name: " & theResult
    on error errMsg
	display dialog "Error: " & errMsg
end try