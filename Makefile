include properties.mk

appName = "appName"
DEVICE?=fr245
devices = `grep 'iq:product id' manifest.xml | sed 's/.*iq:product id="\([^"]*\).*/\1/'`
# Add one line in your source like var v = "1.0";
version = `grep 'var v =' source/DCCApp.mc | sed 's/.*var v = "\([^"]*\).*/\1/'`
JAVA_OPTIONS = JDK_JAVA_OPTIONS="--add-modules=java.xml.bind"

build:
	@$(JAVA_HOME)/bin/java \
	-Xms1g \
	-Dfile.encoding=UTF-8 \
	-Dapple.awt.UIElement=true \
	-jar "$(SDK_HOME)bin/monkeybrains.jar" \
	-o bin/$(appName).prg \
	-f monkey.jungle \
	-y $(PRIVATE_KEY) \
	-d $(DEVICE)_sim \
	-w -l 0 

run: build
	"$(SDK_HOME)/bin/connectiq" &&\
	sleep 3 &&\
	$(JAVA_OPTIONS) \
	"$(SDK_HOME)/bin/monkeydo" bin/$(appName).prg $(DEVICE)

deploy: build
	@cp bin/$(appName).prg $(DEPLOY)

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

test: build
	@$(SDK_HOME)/bin/connectiq &&\
	sleep 3 &&\
	$(JAVA_OPTIONS) \
	"$(SDK_HOME)/bin/monkeydo" bin/$(appName).prg $(DEVICE) -t testSortExchange

# packageall: package1 package2 package3