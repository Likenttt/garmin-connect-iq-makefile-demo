# Garmin Connect IQ Makefile Demo

## Why do I make this repo

Garmin VSCODE has bugs to start simulator [Check this thread](https://forums.garmin.com/developer/connect-iq/f/discussion/276200/vscode-extension-failed-to-launch-the-app-timeout/1502579#1502579)

So it is a workaround to use a makefile.

## Core files

- Makefile
- properties.mk

Remember to have cmake installed in your cli.

## Test

This makefile works fine on my macOS 12.6 zsh 5.8.1 (x86_64-apple-darwin21.0)

## Commands the Makefile contains

### make build

This command will build your project with a `.prg` output. If you want to specify a device like fr955, just use `make build DEVICE=fr955`

### make run

This command will build and run your project in the simulator

### make package

This command will build and export your project to a `.iq` file. Just like what VSCODE command `Monkey C: Export Project` does.

## Some Tips

### How to mark the version of your project?

The first idea hitting us must be using properties. Just add a property `version` and a settings config with readonly value. If we wanna upgrade our project, merely upgrade the version.
However, due to garmin connect iq mechnisiam, if a property has value existed, the version number with a new release won't take effect, in which case we tend to see a obselete version number. Oops, we was expecting to check a update through a version number change. All messed up!

So I often do the above and add a write operation for the version property when the app starts.

### How to mark the version in your output like `appname-v1.1.iq`

Use this command to find the variable you used for version.

```
version = `grep 'var v =' source/DCCApp.mc | sed 's/.*var v = "\([^"]*\).*/\1/'`
```

Then add version for your package command.

```bash
package:
	@$(JAVA_HOME)/bin/java \
	-Dfile.encoding=UTF-8 \
  	-Dapple.awt.UIElement=true \
	-jar "$(SDK_HOME)/bin/monkeybrains.jar" \
  	-o dist/v$(version)/$(appName)-v$(version).iq \
	-e \
	-w \
	-y $(PRIVATE_KEY) \
	-r \
	-f monkey.jungle

```

Have fun~
