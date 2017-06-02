# Detour

An app for a workshop on testing in the real world, where you don't get to start testing things from scratch...ever. 

## What is the App? 
<img style="float: left; padding-right: 2em" src="images/detour.png">

*"A Detour is a choice between two Tasks, each with its own Pros and Cons."* 

This app is inspired by a television show called [The Amazing Race](https://en.wikipedia.org/wiki/The_Amazing_Race_(U.S._TV_series)) where 10-11 teams of two people race around the world, doing assorted silly things related to whatever place they're visiting. 

One type of silly thing they do is called a **Detour** - the team is presented with two choices of Tasks they can do, and they have to choose which one they would like to do. 

On the show, the idea is for the team to choose the thing which will take them the least time, so they can finish the earliest. 

This application is meant to take the same idea, and apply it to more normal travel, so that when you are planning a trip, you can make some informed choices based on questions like: 

- How long is it going to take? 
- How far is it from my primary destination (ie, where I'm staying)?
- How much is it going to cost? 

You can then use this app to set up your own Amazing Race-style plan for a vacation!

## What is already there? 

For most of the application, I've written it with every anti-pattern I can think of, to come up with a better real-world example of the type of application you will run into when taking over a new app. 

I did at least try to organize it well - think of it as the work of someone who's new to coding, but is anal-retentively organized. (No relation to me when  I started whatsoever!)

The application is also somewhat unfinished - there are pieces that are simply TODOs, there are requirements that have been ignored, and there are some Core Data bits that aren't really working at all.

There are a few small sample tests so that if you've never tested before, you can see some examples of how tests can be written, and what happens when they pass and when they fail. 

## What is it *supposed* to do? 

In the interest of time, I'm providing some pieces of information you may not necessarily have access to in the real world: A description of the functionality of the application. 

Answering the question of "Well, what  *should* it be doing?"
 is always a critical first step in writing tests. 
 
- **Application Launch**
	- If there is no logged in user, the login screen should show automatically. 
	- If there is a logged in user, the list of Destinations should show. 
 
- **Login + Registration**
	- Username should be a valid email address. 
		- A valid email address contains at least least one `@`, at least one character on either side of the `@`, and a `.` with one character on either side of a `.` after the first `@`. For example `a@b.c` is valid. `a@bc`, `ab.c`, and `ab@.c` are not.
	- Passwords must be at least six characters long.
	- When creating an account, the user must confirm that their password is correct by re-entering it exactly. 
	- Errors should display if username or password does not validate.
	- Users should be able to tap a button on the login page to show registration. 
	- Users should be able to return to the login page from registration. 

- **Destination List**
	- The logged in user should have some indication of their username displayed so that people who have multiple accounts can tell which one they're signed in to. 
	- The user should be able to log out.
	- Destinations should be in three sections: Things in the future, things happening now, and things in the past. 
		- Something has happened in the past if it has already ended.
		- Something will happen in the future if it has not yet started. 
		- Something is happening now if it started in the past but ends in the future. 
	- Each section of destinations should be sorted.
		- Destinations in the past should be sorted so that the most recently completed destination is the first one on the list.
		- Destinations in the future should be sorted so that the one starting the soonest is the first one on the list
		- Destinations happening now should be sorted so that the one ending the soonest is the first one on the list. 
	- Tapping the + button should take you to a page to add a destination. 
	- Tapping the destination should take you to the detail page for that destination. 
	
- **Destination Detail**
	- The name of the Destination should be the title. 
	- There should be a map of the Destination.
	- The start and end dates should be visible. 
	- There should be a button to add a Detour.
	- There should be a list of detours
	- Tapping on a detour in the list should take you to the Detour Detail view. 


- **Add Destination**
	- The user should be able to input the name of the destination
	- The user should be able to long press a map location as their destination, and have the destination name show up automatically and a pin annotate the destination.
	- The user should be able to input the arrival date for the destination (to the day)
	- The user should be able to input the departure date for the Destination (to the day)
	- Departure date must be after the arrival date.
	- The user should not be able to save a destination if there are any errors in the destination

- **Add Detour/Detour Detail**
	- Two child view controllers for tasks should always be visible.
		- If no tasks exist, both should be in editing mode. 
		- If one task exists, the left one should be in non-editing mode and the right one should be in editing mode
		- If two tasks exist, both should be in non-editing mode.
	-  The title should be derived from the name of the two tasks
		- Actual examples of detour names from the Amazing Race: 
			- Honor the Past or Embrace the Future
			- Wheeze or Cheese
			- Sandy Bottom or Fruity Top
	- If the user exits the view without explicitly hitting save on the task sub-view controller, the changes are not saved. 

- **Add Task**
	- Users should be able to input the name, duration, and cost of the task with text. All three are required. 
	- Users should be able to select a location for the task using a map. 
	- User should be able to save the task and have it be associated with the Detour
	- When a user successfully saves a task, the view should become not editable (the "Task Detail" view)

- **Task Detail**
	- Users should be able to see a list of pros and cons for that Task.
	- Users should be able to add pros and cons for that task
	- Users should be able to delete pros and cons for that task 
	- Users should NOT be able to edit anything else about the task

## TODO

These are some things I would like to add to the application to allow for even more real-world testing

- Actually spin up a server to sync things with for more diabolical testing