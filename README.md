# PassMan

Passman is a password manager for everyday use.

It uses AES 256 encryption which is strong enough to keep your passwords safe.

The master password is the key to unlock all of your passwords.

Warning! if you forget the master password, there is no way to get the other passwords back.

The PMkey.md5 and passwords.pmdb files in your Documents folder is the holder of your passwords.

Don't lose those files even if the application is lost.

## How to use?

If you are launching the app for the first time you need to set a Master Password. This master password is the key to unlock the program and your passwords. You can change it later. If you are using android, it may have issues with permissions and fail to set the master password. Make sure you have allowed the "storage" permission, force close the application and restart. It shouldn't throw any more errors.

There are four tabs in the application:
- New
- Saved
- Master
- About

You can use the first tab to add a new password to the database. Write the name of the site or program or wherever you use a password in the "Name" field. Write the ID and Password in the respective fields. You can also ask the program to generate a password for you. There are four options for generating passwords and they are self-explanatory.

The second tab contains the password you have saved to the database. You can search the passwords using the search box. Select one from the list and click on "Delete" to remove it from the database, "Load" to load the Name-ID-Password in the first tab. You can use it from there. If you want to change the ID or Password, just change them in the respective fields and hit "Save to Database".

The third tab is for changing the master password. Remember, once you change the master password, there is no going back. There are no recovery options in PassMan, so do remember your master password all the time.

The fourth tab is about the developer and contains a bit of information about the program too.

### Keeping backups
If you are an Android user, look for Passwords.pmdb and PMKey.md5 in the documents folder of your Internal storage. These files contain the information and database of your passwords. Even if you reinstall the application, just keep these files and your passwords are safe. 

For Windows, these files are kept in %SYSTEMDRIVE%\Users\Public\Documents folder.

## Information for Developers:

### How to compile?

You need to have Delphi installed on your system. Currently, I am using Delphi 10.3.3 so if you have a lower version, currently check if it compiles or not yourself. 
- Install [Turbopack LockBox3](https://github.com/TurboPack/LockBox3/).
- Open the file "PassMan.dpr" using Delphi.
- Compile
- Deploy if you are compiling for android

### PMDB file format specification

Passwords.pmdb is the file used to store passwords in this program. A pmdb file starts with a 10-byte header which is "PMDB-RUDRA" in string. Then an integer containing the size of the rest can be found. The rest is encrypted with the master password.

PassMan is basically a wrapper for PMDB.pas. For using the PMDB.pas in your application, you need to call Create first. The first parameter is for the master password. The second parameter should be a dedicated seekable stream for PMDB, a TFileStream or TMemorystream is suggested for use. Set the position of the stream to 0 before calling Create.  If you are creating a new pmdb file, set the last parameter to true, else use false.

For adding a password you need a variable for TPassinfo. TPassinfo records three properties just like the "New" tab of the program. TPassinfo is also used to load a password from the PMDB file. Call Add to add a password with a TPassinfo variable or LoadPass to receive password information. If you need to delete a password, just call Delete with the Name. To check if a password exists or not, call Exists with the Name and it will return a boolean. Call List for a list of passwords in the database.

Write or read the master password property to change or get the master password.

Before calling free, you need to call Finalize to save the database in the stream you gave when you called Create. The Finalize procedure clears the stream and writes header and other information to it. Call finalize every single time after you add or delete a password or change the master password to make sure nothing is left unsaved. 

## Vulnerabilities

The passwords are kept unencrypted in memory while the program is running. This can easily be fixed but meh :v Always close the program after you are done.

## Bugs

Go find yourself.


