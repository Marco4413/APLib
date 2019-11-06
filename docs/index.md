# Welcome to the APLib Documentation

![](./images/logo.png)

What does APLib mean? Well, it means "**All Purpose Library**". This is a library for [**Minecraft's Computercraft**](https://computercraft.cc) that aims to make a lot of things much easier to do (like drawing on the screen or making GUIs).
I advise you to check the [**examples**](https://github.com/hds536jhmk/APLib/tree/master/examples) or [**the old attempt at a documentation**](https://github.com/hds536jhmk/APLib/tree/master/old_docs) while the new documentation is being made.

## Terminal arguments

Terminal arguments are arguments with which you can open the library to do simple stuff like getting its version or starting a new project.

* `"libfile" ver` Will print on the screen the current version of the library.
* `"libfile" setup` Will make a new entry in CraftOS's settings called "APLibPath", it's a string that contains where the library is located on the computer's storage.
* `"libfile" create [PATH]` Will make `PATH` a new file that loads the library automatically if setup was done else it will return with an error telling the user to set it up.
