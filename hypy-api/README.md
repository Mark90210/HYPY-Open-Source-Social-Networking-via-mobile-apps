# Perspective
# TEST

## Application Architecture
The [data model](https://docs.google.com/drawings/d/1u87r7280o-xBZBCKQ8lF02rknMK2P2wTxCzd3LJDAdo/ "Information Architecture") shows the relationship between entities in Perspective.


## API Concepts
The Perspective API uses RESTful API practices, see this StackOverflow answer for a quick refresher on the basic concepts of REST and HTTP verbs.
**http://stackoverflow.com/a/2022938/2044980**


## Authentication

Most methods in the API require authentication, which is accomplished via a simple token mechanism:

- The client submits an authentication request by submitting an email and password to the api.
- The API checks the validity of the email and password and, if successful, returns a token.
- The client stores the token and includes it as a parameter in future requests to the API.

Let's look at the authentication flow in more detail below.

1) **Submitting an authentication request**

Take a look at the section titled *API Methods* and find the *POST /session* method.
You will see that it is necessary to make a 'POST' request to the URL '/session'.
Furthermore, you must submit two parameters, 'email' and 'password'.

2) **API responds with token**

After the API performs it's verification of the parameters you submitted, it will return a token.
Referring once again to the documentation, you will find that this method returns a JSON object with a single key: 'token'.

3) **Client includes token in future requests**

This token is used to identify the client in future requests which require authentication.
Let's see this in action by analyzing the *GET /acccount* method below.

You will note that 'token' is a required paramter. Since the HTTP verb for this method is 'GET', the token should be included in the query string.
Thus the full url will be '/account?token=XXXXXX'

> *Note that POST methods will require the token to be placed in the request body instead of the query string.*

In response, the API will return JSON containing the user's account information. You can see from the API specifications that this data will contain various keys: 'email', 'phone', etc.
Some of these keys may contain nested objects or different, so test all API methods before implementing the call in the client.


## API Methods

It is recommended that the API user familiarze himself with the API by making some requests before implementing these calls in the client application.


#### List Events

   # To view galleries and photos

    GET /events
      token: <string>

    JSON
      [
        {
          position: <integer, the position of this group of events relative to other groups of events>,
          title: <string, title of group of events. If name is null, do not display a title for the group>,
          events: [
            {
              id: <integer, id of gallery>,
              user_id: <integer, id of user who created gallery>
              owner_type: <string, "user" or "sponsor">,
              name: <string>,
              description: <string>,
              location: <latitude>,<longitude>,
              hero_image: <url>,
              count_active_users: <integer>,
              count_photos: <integer>,
              status_color: <string, color>,
              bypass_moderation: <boolean>,
              photos:[
                {
                  id: <integer, id of photo>,
                  user_id: <integer, id of user who created photo>,
                  user_name: <string, full name of user who created photo>,
                  user_profile_image: <url, profile image of user who created photo>,
                  file_url: <url>,
                  description: <string>,
                  comments: <array, see /photos/<photo_id> documentation>,
                  count_likes: <integer>,
                  created_at: <datetime w/ timezone>,
                  flagged: <boolean>,
                  moderated: <boolean>,
                  user_has_liked: <boolean>,
                  message: <string, Success message>,
                  message: <datetime w/ timezone>,
                  location: <latitude>,<longitude>,
                  dimension: <[width, height]>,
                  thumb_url: <url,thumbnail image>
                },
                {
                 ... 
                }
              ]
            },
            {
              ...
            },
            ...
          ]
        },
        {
          ...
        },
        ...
      ]

NOTE: Include parameter remove_photos if you want to skip loading photos

#### Create and View Galleries, Photos

   # To create gallery

    POST /galleries
      token: <string>
      name: <string>
      description: <string>
      hero_image: <file>
      location: <string, lat/long, not implemented>

> *encode parameters as multipart/form-data*

    JSON
      {
        id: <integer>,
        user_id: <integer>,
        owner_type: <string>,
        name: <string>,
        description: <string>,
        location: <string>,
        hero_image: <string, url of image>,
        count_active_users: <integer>,
        count_photos: <integer>,
        photos: <array> [
          {
            <see below>
          },
          {
            ...
          },
          ...
        ],
        path: <string>
      }

   # To view gallery details

    GET /galleries/<gallery_id>
      token: <string>

    JSON
      {
        id: <integer, id of gallery>,
        user_id: <id of user who created gallery>
        owner_type: <string, "user" or "sponsor">,
        name: <string>,
        description: <string>,
        location: <latitude>,<longitude>,
        hero_image: <url>,
        count_active_users: <integer>,
        count_photos: <integer>,
        photos: <array> [
          {
            id: <integer, id of photo>,
            user_id: <integer, id of user who created photo>,
            user_name: <string, full name of user who created photo>,
            user_profile_image: <url, profile image of user who created photo>,
            file_url: <url>,
            description: <string>,
            comments: <array, see /photos/<photo_id> documentation>,
            count_likes: <integer>,
            created_at: <datetime w/ timezone>,
            flagged: <boolean>,
            moderated: <boolean>,
            user_has_liked: <boolean>,
            message: <string, Success message>,
            message: <datetime w/ timezone>,
            location: <latitude>,<longitude>,
            dimension: <[width, height]>,
            thumb_url: <url,thumbnail image>
          },
          {
            ...
          },
          ...
        ]
      }

   # To view all photos for a gallery
       
    GET /galleries/<gallery_id>/photos
      token: <string>
      since_id: <integer, optional>

    JSON
      [
        {
          id: <integer, id of photo>,
          user_id: <integer, id of user who created photo>,
          user_name: <string, full name of user who created photo>,
          user_profile_image: <url, profile image of user who created photo>,
          file_url: <url>,
          description: <string>,
          comments: <array, see /photos/<photo_id> documentation>,
          count_likes: <integer>,
          created_at: <datetime w/ timezone>,
          flagged: <boolean>,
          moderated: <boolean>,
          user_has_liked: <boolean>,
          message: <string, Success message>,
          message: <datetime w/ timezone>,
          location: <latitude>,<longitude>,
          dimension: <[width, height]>,
          thumb_url: <url,thumbnail image>
        },
        {
          ...
        },
        ...
      ]

#### Add, View, Like, and Comment on Photos
   # To add photo in a gallery

    POST /galleries/<gallery_id>/photos
      token: <string>
      description: <string>
      photo: <binary>

> *encode parameters as multipart/form-data*

    JSON
      {
        id: <integer>,
        user_id: <integer>,
        user_name: <string>,
        user_profile_image: <string>,
        file_url: <string>,
        description: <string>,
        created_at: <datetime>,
        flagged: <boolean>,
        moderated: <boolean>,
        user_has_liked: <boolean>,
        message: <string, Success message>,
        message: <datetime w/ timezone>,
        location: <latitude>,<longitude>,
        dimension: <[width, height]>,
        thumb_url: <url,thumbnail image>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*    

   # To view photo details

    GET /photos/<photo_id>
      token: <string>

    JSON
      {
        id: <integer>,
        user_id: <integer>,
        user_name: <string>,
        user_profile_image: <string>,
        file_url: <string>,
        flagged: <boolean>,
        description: <string>,
        comments: <array> [
          {
            id: <integer>,
            user_id: <integer>,
            user_name: <string, user name>,
            user_profile_image: <url, profile image of user who created photo>,
            photo_id: <integer>,
            text: <string>,
            flagged: <boolean>,
            created_at: <datetime>
          },
          {
            ...
          },
          ...
        ],
        count_likes: <integer>,
        created_at: <datetime>,
        flagged: <boolean>,
        moderated: <boolean>,
        user_has_liked: <boolean>,
        message: <string, Success message>,
        message: <datetime w/ timezone>,
        location: <latitude>,<longitude>,
        dimension: <[width, height]>,
        thumb_url: <url,thumbnail image>
      }

   # To add likes on photo

    POST /photos/<photo_id/likes
      token: <string>

    JSON
      {
        id: <integer>,
        user_id: <integer>,
        photo_id: <integer>,
        created_at: <datetime>,
        user_name: <string, user name>,
        user_profile_image: <url, profile image of user who created photo>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*

   # To view all likes for a photo

    GET /photos/<photo_id/likes

    JSON
      [
        {
          id: <integer>,
          user_id: <integer>,
          photo_id: <integer>,
          created_at: <datetime>,
          user_name: <string, user name>,
          user_profile_image: <url, profile image of user who created photo>
        },
        {
          ...
        }
      ]  

   # To add comments on a photo
      
    POST /galleries/<gallery_id>/photos/<photo_id>/comments
      token: <string>
      text: <string>

    JSON
      {
        id: <integer>,
        user_id: <integer>,
        user_name: <string, user name>,
        user_profile_image: <url, profile image of user who created photo>,
        photo_id: <integer>,
        text: <string>,
        flagged: <boolean>,
        created_at: <datetime>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*


#### Flag Photos and Comments

   # To add flag on a photo

    POST /photos/<photo_id>/flag
      token: <string>

    JSON
      {
        id: <integer>,
        user_id: <integer>,
        photo_id: <integer>,
        created_at: <datetime>
      }


#### Create, Confirm, View, and Update Own Profile
  
   # To create new user and sending verification code

    POST /users/me
      phone: <string, the user's 10 digit phone number along with country code>

    JSON
      {
        success: <boolean>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*    

   # To confirm user account
      
    POST /users/me/confirmation
      phone: <string, the user's 10 digit phone number along with country code as called in previous method>
      verification_code: <string, from text message>

    JSON
      {
        success: <boolean>,
        token: <string>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*

   # To view user details
      
    GET /users/me
      token: <string>

    JSON
      {
        first_name: <string>,
        last_name: <string>,
        bio: <string>,
        email: <string>,
        phone: <string>,
        profile_image: <string>,
        created_at: <datetime>,
        device_identifier: <string>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*

   # To update an user
      
    PUT /users/me
      token: <string>
      first_name: <string, optional, include to update first_name>
      last_name: <string, optional, include to update last_name>
      bio: <string, optional, to update bio>
      email: <string, optional, to update email>,
      profile_image: <string, optional, to update profile image>,
      phone: <string, optional, to update phone>,
      device_identifier: <string>

    JSON
      {
        first_name: <string>,
        last_name: <string>,
        bio: <string>,
        email: <string>,
        profile_image: <string>,
        phone: <string>,
        created_at: <datetime>,
        device_identifier: <string>
      }

  > *Note: API will throw 401 httpresponse status code with error 'Admin has blocked your account!', if user is blocked.*    

####Splash Image
  # To view a splash image

    GET /splash
     
    JSON
      {
        "splash_image": <string, splash image url>
      }

####Heroku Release Version 
  # To fetch current release version

    GET /version
     
    JSON
      {
        "version": <version number>
      }

## Heroku Build and Deploy process

From Heroku dashboard (https://dashboard.heroku.com/apps), create a new app. Make sure Stack version of new app is pointing to **Heroku-16**. If somehow it's **Cedar-14**, then just upgrade to **Heroku-16**.

#### Adding Config variables for AWS S3 Bucket and Twilio

Navigate to **settings** tab of launched app and create following config variables:

- AWS_BUCKET    
- AWS_IAM_KEY 
- AWS_IAM_SECRET
- AWS_REGION
- TWILIO_NUMBER
- TWILIO_SID
- TWILIO_TOKEN

For AWS region, value need to be presented from following list:

| Region Name  | Region |
| --- | :---: |
| US East (Ohio)  | `us-east-2`  |
| US East (N. Virginia)  | `us-east-1`  |
| US West (N. California)  | `us-west-1`  |
| US West (Oregon)  | `us-west-2`  |
| Asia Pacific (Mumbai)  | `ap-south-1`  |
| Asia Pacific (Seoul)  | `ap-northeast-2`  |
| Asia Pacific (Singapore)  | `ap-southeast-1`  |
| Asia Pacific (Sydney)  | `ap-southeast-2`  |
| Asia Pacific (Tokyo)  | `ap-northeast-1`  |

#### Adding Config variables for Heroku version numbers

Execute below command from Heroku CLI:

> `heroku labs:enable runtime-dyno-metadata -a app_name`

Running above command would create environment variables to store heroku release related info, including version number. Each time code is deployed on heroku, these environment variables would get refreshed automatically and point to latest.

#### Adding buildpacks

Navigate to **settings** tab of launched app and add following buildpacks entry under **Buildpacks** section in same sequence as listed below:

- https://github.com/kontentcore/heroku-buildpack-ffmpeg
- heroku/ruby

This will install `FFMPEG service`, required for creating thumbnails, first and then launch the ruby app during deployment.

