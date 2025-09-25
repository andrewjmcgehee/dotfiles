(*
  This script opens a video file in QuickTime Player at a specific timestamp.
  The script expects two arguments to be passed when it is run:
  1. The absolute POSIX file path of the video (e.g., "/Users/username/Movies/my_video.mp4").
  2. The timestamp in seconds (e.g., "60.5" for 60.5 seconds).

  Example usage from the command line:
  osascript /path/to/this/script.scpt "/Users/username/Movies/my_video.mp4" "60.5"
*)

on run argv
	if (count of argv) is not 2 then
		display dialog "Usage: osascript " & POSIX path of (path to me) & " <video_path> <timestamp_in_seconds>" buttons {"OK"} default button 1 with icon stop
		error number -128
	end if

	set videoPath to item 1 of argv
	set timeStamp to item 2 of argv

  set totalSeconds to my parseTimestamp(timeStamp)

	tell application "QuickTime Player"
		try
			set videoDocument to open POSIX file videoPath
			set current time of videoDocument to totalSeconds
			activate
		on error errMsg number errNum
			if errNum = -43 then
				-- Error -43 is "file not found"
				display dialog "Error: File not found at " & videoPath buttons {"OK"} default button 1 with icon stop
			else
				display dialog "An error occurred: " & errMsg buttons {"OK"} default button 1 with icon stop
			end if
		end try
	end tell
end run

on parseTimestamp(theTimestamp)
	try
		set totalSeconds to theTimestamp as number
		return totalSeconds
	on error
		set originalDelimiters to AppleScript's text item delimiters
		set AppleScript's text item delimiters to ":"
		set timeParts to text items of theTimestamp
		set AppleScript's text item delimiters to originalDelimiters

		set totalSeconds to 0
		set partCount to count of timeParts

		if partCount = 3 then
			-- HH:MM:SS
			set totalSeconds to (item 1 of timeParts as number) * 3600 + (item 2 of timeParts as number) * 60 + (item 3 of timeParts as number)
		else if partCount = 2 then
			-- MM:SS
			set totalSeconds to (item 1 of timeParts as number) * 60 + (item 2 of timeParts as number)
		else if partCount = 1 then
			-- SS format (if it was passed as a string)
			set totalSeconds to (item 1 of timeParts as number)
		else
			display dialog "Error: Invalid timestamp format. Please use HH:MM:SS, MM:SS, or a number of seconds." buttons {"OK"} default button 1 with icon stop
			error number -128
		end if
		return totalSeconds
	end try
end parseTimestamp
