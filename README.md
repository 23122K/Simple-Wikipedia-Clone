# Simple Wikipedia Clone
A Wikipedia-like app created in SwiftUI for learning purposes.
Primary goal was to learn how to fetch data using Wikipedia API and then persist (cache) them. Due to a fact that  was my primary objective, I didn't go deep into UI/UX design - just made it look pleasant to the eye.

## About the project
As the user enters a topic of interests into the search bar, the app fetches matching topics and shows them as a list of suggestions.
When clicked on any topic from mentioned list, another request is made to fetch Page content (eg. Title and Extract - Brief description) which are then directly decoded and persisted 
using CoreData framework and page content is shown to the user. 
Fetched page data is available to the user as it is persisted and act like so called history in case of lack of internet connection.
<p float="left" align="center">
  <img src="https://i.imgur.com/ZjPp5nZ.png" width="200">
  <img src="https://i.imgur.com/jWKsZd7.png" width="200">
  <img src="https://i.imgur.com/OChyFjI.png" width="200">
  <img src="https://i.imgur.com/GQeLGu4.png" width="200">
</p>

## Frameworks and Architecture
### Architecute
Using an architecture is a widely accepted practice among the developer community. In my case, I have opted for the MVVM architecture,
which I believe is the most widely used architecture.

### Framworks
In terms of frameworks, I decided to stick with the first-party ones created by Apple, specifically Combine and CoreData.

CoreData as mentioned earier was used to persist data onto the divice in case when user's device goes offline.
Combine has been havily incorporated into this project as i found that declarative approach makes code more readable and easy to understand.
Framework itself has been used to handle user input, drive various ui components and efficiently manage network responses.

## Roadmap
- [x] Search functionality
- [x] History
- [ ] Better error handling
- [ ] Tests
    - [ ] Unit tests
    - [ ] UI tests
