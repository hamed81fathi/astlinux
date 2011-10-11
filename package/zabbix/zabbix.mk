#############################################################
#
# zabbix
#
#############################################################

ZABBIX_VERSION = 1.6.8
ZABBIX_SOURCE = zabbix-$(ZABBIX_VERSION).tar.gz
ZABBIX_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/zabbix

ZABBIX_CONF_OPT = \
	--enable-agent

define ZABBIX_CONFIGURE_CMDS
        (cd $(@D); \
                $(TARGET_CONFIGURE_ARGS) \
                $(TARGET_CONFIGURE_OPTS) \
                ./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
        	--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--disable-gtk-doc \
		$(ZABBIX_CONF_OPT) \
        )
endef

define ZABBIX_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/src/zabbix_agent/zabbix_agentd $(TARGET_DIR)/usr/bin/zabbix_agentd
endef

define ZABBIX_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/zabbix_agentd
endef

$(eval $(call AUTOTARGETS,package,zabbix))
