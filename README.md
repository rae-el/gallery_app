# gallery_app

A Flutter built Gallery App

## Description

An app with authentication where you can upload, view, and favourite photos.

### Required features

Done

- Signing in
- Signing up
- Uploading and removing pictures
- Tapping to expand pictures and viewing their details
- Favourite pictures
- Delete pictures

To Do

- Zooming in and out
- Sorting pictures

#### Models

##### User

- Username - required - string
- Email - required - string
- Password - required - string
- Name - not required - string
- Description - not required - text
- ProfilePicture - not required - profile_image_object
- Images - not required - array[image_object]
- Favourites - not required - array[image_object]

- image_object
  - path - required - string
  - image - required - image
  - title - not required - string
  - description - not required - text
  - favourite - required - bool

#### Views

- all views must have navigation

##### Startup

- View:
  - basic loading and logo
- View model:
  - automatically check for authorization and navigate

##### Authorization

- View:
  - basic form
- View model:
  - connect to firebase authorization service

##### Home

- View:
  - grid of images
  - small menu
- View model:
  - gather images from user
  - ability to add/remove favourites

##### Profile

- View:
  - semi-editable form
  - image
  - small menu
- View model:
  - gather user information
  - edit some user information

##### Favourites

- View:
  - grid of favourite images
  - small menu
- View model:
  - gather favourite images from user
  - ability to remove favourites
  - change order of images (date, drag and drop?)

##### Image

- View:
  - image
  - small menu
- View model:
  - gather image information
  - ability to remove image
  - zoom in and out
