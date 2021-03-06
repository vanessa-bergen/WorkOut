# WorkOut
Node.js and MongoDB backend fitness iOS app that allows users to create custom interval training workouts.

## Screenshots
### Creating Exercises
<img src="images/wo1.png" width="25%" hspace="20"> <img src="images/wo2.png" width="25%" hspace="20"> 
### Creating A Workout
<img src="images/wo3.png" width="24%"> <img src="images/wo4.png" width="24%"> <img src="images/wo5.png" width="24%"> <img src="images/wo6.png" width="24%">
### Starting A Workout
<img src="images/wo7.png" width="24%"> <img src="images/wo8.png" width="24%"> <img src="images/wo10.png" width="24%"> <img src="images/wo11.png" width="24%">
### Scheduling A Workout
<img src="images/wo12.png" width="25%" hspace="20"> <img src="images/wo15.png" width="25%" hspace="20"> 
### Configuring Settings
<img src="images/wo13.png" width="25%" hspace="20"> <img src="images/wo14.png" width="25%" hspace="20"> 

## Motivation
Found myself getting bored after repeatedly watching the same YouTube workout videos. Wanted to be able to choose different exercises and play my own music in the background. Decided to create an app where I could personalize my workouts. 

## Features
* Can create and add exercises to a workout specifying the length of time to perform the exercise and optionally add a rest time
* Visual progress bar which displays the time left in the exercise
* Visual progress bar which displays the percentage of the workout complete 
* Option to add a voice to read the name of the upcoming exercise
* Option to add sound and/or haptics to indicate the start and end of an exercise
* Ability to schedule a workout in the iOS calendar 

## Challenges
* Difficulty working with asynchronous Node.js, used async functions to wait for all calls to the database to finish before saving the object

## Things I Learned
* Used async functions to handle asynchronous operations as if they were synchronous
* Used REST to pass JSON objects from the client to the server and vice versa

## Future Improvement
* Need to add the ability to cache workouts that have been created. This way the app can be used offline. As it is, if there is no access to the server, previously create workouts will not appear when the app is first opened.
* Improve how to reorder exercises when creating a workout
* Add option to share workouts
* Allow the app to run in the background

