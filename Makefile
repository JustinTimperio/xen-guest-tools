# Define Version
PACKAGE = xen-guest-tools
VERSION_MAJOR=1
VERSION_MINOR=0
VERSION_PATCH=0
XGT_VERSION = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
GIT_RELEASE := $(shell git rev-list HEAD | wc -l)

ARCH := $(shell go version|awk -F'/' '{print $$2}')
ifeq ($(ARCH), amd64)
	ARCH = x86_64
endif

# Define File Locations
REPO = $(shell pwd)
GO_SOURCE = $(REPO)/go-source
SCRIPTS = $(REPO)/scripts
SYSFS = $(REPO)/sysfs
BUILD_DIR = $(REPO)/build
GO_BUILD_DIR = $(BUILD_DIR)/gobuild
STAGE_DIR = $(BUILD_DIR)/stage
GO_BIN_DIR = $(BUILD_DIR)/bins
DIST_DIR = $(BUILD_DIR)/out

# GOLANG Build Flags
GO_BUILD = go build
GO_FLAGS = -v

# Define GOLANG Source and Targets 
OBJECTS :=
OBJECTS += $(GO_BIN_DIR)/xen-daemon
OBJECTS += $(GO_BIN_DIR)/xenstore

XENSTORE_SOURCES :=
XENSTORE_SOURCES += ./go-source/xenstore/xenstore.go
XENSTORE_SOURCES += ./go-source/xenstoreclient/xenstore.go

XEN_DAEMON_SOURCES :=
XEN_DAEMON_SOURCES += ./go-source/xen-daemon/xen-daemon.go
XEN_DAEMON_SOURCES += ./go-source/syslog/syslog.go
XEN_DAEMON_SOURCES += ./go-source/system/system.go
XEN_DAEMON_SOURCES += ./go-source/guestmetric/guestmetric.go
XEN_DAEMON_SOURCES += ./go-source/guestmetric/guestmetric_linux.go
XEN_DAEMON_SOURCES += ./go-source/xenstoreclient/xenstore.go


# Stage Build Process
.PHONY: build
build: $(DIST_DIR)/$(PACKAGE)_$(XGT_VERSION)-$(GIT_RELEASE)_$(ARCH).tgz

.PHONY: clean
clean:
	$(RM) -rf $(BUILD_DIR)


# Build Tarball
$(DIST_DIR)/$(PACKAGE)_$(XGT_VERSION)-$(GIT_RELEASE)_$(ARCH).tgz: $(OBJECTS)
		(mkdir -p $(DIST_DIR) ; \
		install -d $(STAGE_DIR)/etc/init.d/ ; \
		install -d $(STAGE_DIR)/usr/sbin/ ; \
		install -d $(STAGE_DIR)/usr/bin/ ; \
		install -d $(STAGE_DIR)/etc/udev/rules.d/ ; \
		install -m 755 $(SYSFS)/xen-guest-tools.init $(STAGE_DIR)/etc/init.d/xen-guest-tools ; \
		install -m 644 $(SYSFS)/xen-vcpu-hotplug.rules $(STAGE_DIR)/etc/udev/rules.d/z10_xen-vcpu-hotplug.rules ; \
		install -m 644 $(SYSFS)/xen-guest-tools.service $(STAGE_DIR)/etc/udev/rules.d/z10_xen-vcpu-hotplug.rules ; \
		install -m 755 $(SCRIPTS)/identify-distribution.sh $(STAGE_DIR)/usr/sbin/xen-identify-distribution ; \
		install -m 755 $(GO_BIN_DIR)/xen-daemon $(STAGE_DIR)/usr/sbin/xen-daemon ; \
		install -m 755 $(GO_BIN_DIR)/xenstore $(STAGE_DIR)/usr/bin/xenstore ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-read ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-write ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-exists ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-rm ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-list ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-ls ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-chmod ; \
		ln -sf xenstore $(STAGE_DIR)/usr/bin/xenstore-watch ; \
		cd $(STAGE_DIR) ; \
		tar zcf $@ * )


$(GO_BIN_DIR)/xen-daemon: $(XEN_DAEMON_SOURCES:%=$(GO_BUILD_DIR)/%)
	mkdir -p $(GO_BIN_DIR)
	$(GO_BUILD) $(GO_FLAGS) -o $@ $<

$(GO_BIN_DIR)/xenstore: $(XENSTORE_SOURCES:%=$(GO_BUILD_DIR)/%) $(GOROOT)
	mkdir -p $(GO_BIN_DIR)
	$(GO_BUILD) $(GO_FLAGS) -o $@ $<

$(GO_BUILD_DIR)/%: $(REPO)/%
	mkdir -p $$(dirname $@)
	cat $< | \
	sed -e "s/@VERSION_MAJOR@/$(VERSION_MAJOR)/g" | \
	sed -e "s/@VERSION_MINOR@/$(VERSION_MINOR)/g" | \
	sed -e "s/@VERSION_PATCH@/$(VERSION_PATCH)/g" | \
	sed -e "s/@GIT_RELEASE@/$(GIT_RELEASE)/g" \
	> $@
