property app_to_check : "RuneLite"
property app_to_launch : "Jagex Launcher"

tell application "System Events"
	set app_is_running to (app_to_check is in the name of every process)
end tell

if app_is_running then
	tell application app_to_check
		activate
	end tell
else
	tell application app_to_launch
		launch
    activate
	end tell
end if

