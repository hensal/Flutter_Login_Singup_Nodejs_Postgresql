# Simple Login Signup application

Step1:
create the .env folder inside the server folder inside the project 
and write the below.
Note: This is generated from the google api so that we can send the forgot password link to individual user 
using this email.This is just the demo, you need to create user and pass from google console as shown in screenshot below.
LInk:https://myaccount.google.com/

     EMAIL_USER=kn55@gmail.com   
     EMAIL_PASS=pkyz kwuc uiqu ztqd

![app](https://github.com/user-attachments/assets/25d9a7cc-2db4-4365-a02c-f269511073aa)

![app2](https://github.com/user-attachments/assets/eafc3d49-0762-4d9b-9cc1-73637a9a5253)
 
Step-2:
Here, I used NodeJS for the back with the node nodemailer to send the email link to user.

Step-3:
In the index.html file inside the Web folder of flutter application. Write below code.

      <base href="/">

Step-4:
Packages are listed below:

      go_router: ^14.8.0
      intl_phone_field: ^3.2.0
      http: ^0.13.4
      go_router: ^14.8.1
      shared_preferences: ^2.3.3

Step-5:
The # sing in the URL route might give the error will reseting the password.
SO use setUrlStrategy package of flutter in web application

UI:

![login apge](https://github.com/user-attachments/assets/b024e909-39c2-4871-902b-3a37170a3d60)

![crea](https://github.com/user-attachments/assets/20a5f673-fd9c-44d0-94e8-e73a17ed266e)

![fpr](https://github.com/user-attachments/assets/9deb683c-64be-4216-afcd-118410456b6b)

![reset password](https://github.com/user-attachments/assets/85f735ba-53d9-4703-9b5e-5471b2a4dd2c)







