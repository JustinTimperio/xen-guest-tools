###
#
#
#
#
###

# Define Version
PACKAGE 						= xen-guest-tools
VERSION_MAJOR 			= 1
VERSION_MINOR 			= 0
VERSION_PATCH 			= 0
XGT_VERSION 				= $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH)
GIT_RELEASE 				= $(shell git rev-list HEAD | wc -l)

# Define Repo Folder Locations
REPO         				= $(shell pwd)
GO_SOURCE    				= $(REPO)/go-source
SCRIPTS      				= $(REPO)/scripts
SYSFS        				= $(REPO)/sysfs
BUILD_DIR    				= $(REPO)/build

# Define Build Folder Locations
STAGE_DIR    				= $(BUILD_DIR)/stage
DIST_DIR     				= $(BUILD_DIR)/out

# GOLANG Build Flags
GO_BUILD 						= go build
GO_FLAGS 						= -v


# Figure Out Arch of System
ARCH := $(shell go version | awk -F '[/]' '{print $$2}')
ifeq ($(ARCH), amd64)
	ARCH = x86_64
endif

# Add Function That Adds Version To Source Files
define add_version
	cat $(1) | \
	sed -e "s/@VERSION_MAJOR@/$(VERSION_MAJOR)/g" | \
	sed -e "s/@VERSION_MINOR@/$(VERSION_MINOR)/g" | \
	sed -e "s/@VERSION_PATCH@/$(VERSION_PATCH)/g" | \
	sed -e "s/@GIT_RELEASE@/$(GIT_RELEASE)/g" > $(2)
endef


all: prebuild
	# Build XenStore
	GOOS=linux $(GO_BUILD) $(GO_FLAGS) -o $(DIST_DIR)/xenstore_linux_v$(XGT_VERSION) $(STAGE_DIR)/xenstore/xenstore.go
	GOOS=freebsd $(GO_BUILD) $(GO_FLAGS) -o $(DIST_DIR)/xenstore_freebsd_v$(XGT_VERSION) $(STAGE_DIR)/xenstore/xenstore.go
	# Build Xen-Daemon
	GOOS=linux $(GO_BUILD) $(GO_FLAGS) -o $(DIST_DIR)/xen-daemon_linux_v$(XGT_VERSION) $(STAGE_DIR)/xen-daemon/xen-daemon.go
	GOOS=freebsd $(GO_BUILD) $(GO_FLAGS) -o $(DIST_DIR)/xen-daemon_freebsd_v$(XGT_VERSION) $(STAGE_DIR)/xen-daemon/xen-daemon.go


prebuild:
	# Clean Previous Run and Make Dirs
	rm -rf $(BUILD_DIR)
	mkdir $(BUILD_DIR)
	mkdir $(STAGE_DIR)
	mkdir $(STAGE_DIR)/xenstore
	mkdir $(STAGE_DIR)/xenstoreclient
	mkdir $(STAGE_DIR)/syslog
	mkdir $(STAGE_DIR)/system
	mkdir $(STAGE_DIR)/xen-daemon
	mkdir $(STAGE_DIR)/guestmetric
	mkdir $(DIST_DIR)
	mkdir $(DIST_DIR)/sysfs
	# Copy Sysfs Files
	cp $(SCRIPTS)/identify-distribution.sh $(DIST_DIR)/sysfs/identify-distribution
	cp $(SYSFS)/xen-guest-tools.init $(DIST_DIR)/sysfs/xen-guest-tools.init
	cp $(SYSFS)/xen-guest-tools.initd $(DIST_DIR)/sysfs/xen-guest-tools.initd
	cp $(SYSFS)/xenguesttools.in $(DIST_DIR)/sysfs/xenguesttools.in
	cp $(SYSFS)/xen-guest-tools.service $(DIST_DIR)/sysfs/xen-guest-tools.service
	cp $(SYSFS)/xen-vcpu-hotplug.rules $(DIST_DIR)/sysfs/xen-vcpu-hotplug.rules
	cp $(REPO)/LICENSE $(DIST_DIR)/LICENSE
	cp $(REPO)/LICENSE_Citrix $(DIST_DIR)/LICENSE_Citrix
	# Copy Source Go Files
	$(call add_version,$(GO_SOURCE)/xenstore/xenstore.go,$(STAGE_DIR)/xenstore/xenstore.go)
	$(call add_version,$(GO_SOURCE)/xenstoreclient/xenstoreclient.go,$(STAGE_DIR)/xenstoreclient/xenstoreclient.go)
	$(call add_version,$(GO_SOURCE)/syslog/syslog.go,$(STAGE_DIR)/syslog/syslog.go)
	$(call add_version,$(GO_SOURCE)/system/system.go,$(STAGE_DIR)/system/system.go)
	$(call add_version,$(GO_SOURCE)/xen-daemon/xen-daemon.go,$(STAGE_DIR)/xen-daemon/xen-daemon.go)
	$(call add_version,$(GO_SOURCE)/guestmetric/guestmetric.go,$(STAGE_DIR)/guestmetric/guestmetric.go)
	$(call add_version,$(GO_SOURCE)/guestmetric/guestmetric_linux.go,$(STAGE_DIR)/guestmetric/guestmetric_linux.go)
