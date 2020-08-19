# PassMan

Passman is a password manager for everyday use.

It uses AES 256 encryption which is strong enough to keep your passwords safe.

The master password is the key to unlock all of your passwords.

Warning! if you forget the  master password, there is no way to get the other passwords back.

The PMkey.md5 and passwords.pmdb files in your documents folder is the holder of your passwords.

Don't loose those files even if the application is lost.

## How to use:

If you are launching the app for the first time you need to set a Master Password. This master password is the key to unlock the program and your passwords. You can change it later. If you are using android, it may have issues with permissions and fail to set the master password. Make sure you have allowed the "storage" permission, force close the application and restart. It shouldn't throw any more errors.

There are four tabs in the application:
- New
- Saved
- Master
- About

You can use the first tab to add a new password to the database. Write the name of the site or program or wherever you use password in the "Name" field. Write the ID and Password in the respective fields. You can also ask the program to generate a password for you. There are four options for generating passwords and they are self-explanatory.

The second tab contains the password you have saved to database. You can search the passwords using the searchbox. Select once from the list and click on "Load" to load the Name-ID-Password in the first tab. You can use it from there. If you want to change the ID or Password, just change them in the respective fields and hit "Save to Database".

The third tab is for changing the master password. Remember, once you change the master password, there is no going back. There are no recovery options in PassMan, so do remember your master password all the time.

The fourth tab is about the developer and contains a bit of information about the program too.

### Keeping backups
If you are an android user, look for Passwords.pmdb and PMKey.md5 in the documents folder of your Internal storage. These files contain the infomation and database of your passwords. Even if you reinstall the application, just keep these files and your passwords are safe. 

For Windows, these files are kept in %SYSTEMDRIVE%\Users\Public\Documents folder.
