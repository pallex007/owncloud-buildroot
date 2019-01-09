################################################################################
#
# owncloud (From http://lists.busybox.net/pipermail/buildroot/2016-March/156370.html)
#
################################################################################

OWNCLOUD_VERSION = 9.0.0
OWNCLOUD_SOURCE = owncloud-$(OWNCLOUD_VERSION).tar.bz2
OWNCLOUD_SITE = https://download.owncloud.org/community
OWNCLOUD_DEPENDENCIES =
OWNCLOUD_LICENSE = AGPL
OWNCLOUD_LICENSE_FILES = COPYING-AGPL

define OWNCLOUD_INSTALL_TARGET_CMDS
	#install files /usr/lib
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -a $(@D) $(TARGET_DIR)/usr/lib/owncloud
	#move dynamic files in /var/lib and make symbolic links
	mkdir -p $(TARGET_DIR)/var/lib/owncloud
	mkdir -p $(TARGET_DIR)/var/lib/owncloud/data
	rm -rf $(TARGET_DIR)/var/lib/owncloud/config
	rm -rf $(TARGET_DIR)/var/lib/owncloud/apps
	mv -f $(TARGET_DIR)/usr/lib/owncloud/owncloud-9.0.0/config $(TARGET_DIR)/var/lib/owncloud/
	mv -f $(TARGET_DIR)/usr/lib/owncloud/owncloud-9.0.0/apps $(TARGET_DIR)/var/lib/owncloud/
	#use relative path so that permissions can be set by OWNCLOUD_PERMISSIONS hook
	ln -s ../../../var/lib/owncloud/data $(TARGET_DIR)/usr/lib/owncloud/data
	ln -s ../../../var/lib/owncloud/config $(TARGET_DIR)/usr/lib/owncloud/config
	ln -s ../../../var/lib/owncloud/apps $(TARGET_DIR)/usr/lib/owncloud/apps
endef

define OWNCLOUD_PERMISSIONS
	/usr/lib/owncloud r -1 root root - - - - -
	/var/lib/owncloud r -1 www-data www-data - - - - -
endef

$(eval $(generic-package))
