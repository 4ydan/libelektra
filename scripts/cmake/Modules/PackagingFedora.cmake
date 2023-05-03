# ~~~
# In this file CPACK_RPM_* vars necessary by CPack RPM
# to generate RPM packages are set. Also RPM package specifc
# files are installed.
# ~~~

set (CPACK_RPM_PACKAGE_VERSION "${PROJECT_VERSION}")
set (CPACK_RPM_PACKAGE_RELEASE "${CPACK_PACKAGE_RELEASE}")
set (RPM_VERSION_RELEASE "${CPACK_RPM_PACKAGE_VERSION}-${CPACK_RPM_PACKAGE_RELEASE}")

set (CPACK_GENERATOR "RPM")
set (CPACK_RPM_COMPONENT_INSTALL "ON")
set (CPACK_RPM_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_PACKAGE_VENDOR "libelektra (${PACKAGE_URL})")
set (CPACK_RPM_FILE_NAME RPM-DEFAULT)
set (CPACK_RPM_PACKAGE_AUTOREQ 1)
set (CPACK_RPM_PACKAGE_AUTOPROV 1)
set (CPACK_RPM_PACKAGE_AUTOREQPROV 1)

# package is not relocatable:
unset (CPACK_RPM_PACKAGE_RELOCATABLE)
unset (CPACK_RPM_PACKAGE_RELOCATABLE CACHE)

set (CPACK_RPM_SPEC_MORE_DEFINE "%define ignore \#")

# workaround for openSUSE not running ldconfig
set (CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${CMAKE_SOURCE_DIR}/scripts/dev/ldconfig.sh")
set (CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE "${CMAKE_SOURCE_DIR}/scripts/dev/ldconfig.sh")

set (CPACK_RPM_CHANGELOG_FILE "${CMAKE_SOURCE_DIR}/scripts/packaging/fedora/changelog")

execute_process (COMMAND bash "${CMAKE_SOURCE_DIR}/scripts/packaging/fedora/map_licenses.sh" "${CMAKE_SOURCE_DIR}/.reuse/dep5"
		 OUTPUT_VARIABLE THIR_PARTY_LICENSES_STR)
set (CPACK_RPM_PACKAGE_LICENSE "${THIR_PARTY_LICENSES_STR} \n # For a breakdown of the licensing, see copyright (.reuse/dep5)")
# install license files
configure_file ("${CMAKE_SOURCE_DIR}/LICENSE.md" "${CMAKE_BINARY_DIR}/doc/LICENSE" COPYONLY)
configure_file ("${CMAKE_SOURCE_DIR}/.reuse/dep5" "${CMAKE_BINARY_DIR}/doc/copyright" COPYONLY)
foreach (component ${PACKAGES})
	install (
		FILES "${CMAKE_BINARY_DIR}/doc/LICENSE" "${CMAKE_BINARY_DIR}/doc/copyright"
		COMPONENT ${component}
		DESTINATION "share/licenses/${component}")
endforeach ()

set (
	CPACK_RPM_BUILDREQUIRES
	"make, git augeas-devel, cmake3, docbook-style-xsl, doxygen
	discount, gawk, gcc-c++, GConf2-devel, graphviz, libcurl-devel, libdb-devel,
	libdrm-devel, libgit2-devel, libxml2-devel, lua-devel, python3-devel, python-devel,
	qt5-qtdeclarative-devel, qt5-qtsvg-devel, swig, systemd-devel, yajl-devel,
	java-11-openjdk-devel, jna, ruby-devel, zeromq-devel")

if (CPACK_PACKAGE_ARCHITECTURE MATCHES "x86_64")
	# workaround because rpm autoprov doesn't include symlinks
	set (CPACK_RPM_LIBELEKTRA${SO_VERSION}_PACKAGE_PROVIDES "libelektra-plugin-resolver.so()(64bit), libelektra-plugin-storage.so()(64bit)")
endif ()

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}_PACKAGE_SUGGESTS "elektra-doc, ${ALL_PLUGINS_STR}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FULL_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-FULL_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FULL_PACKAGE_CONFLICTS
     "libelektra5 < ${CPACK_RPM_PACKAGE_VERSION}, elektra-tests < ${CPACK_RPM_PACKAGE_VERSION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FULL_PACKAGE_SUGGESTS "elektra-doc, ${ALL_PLUGINS_STR}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FULL_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-FULL_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FULL_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FULL_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_PACKAGE_SUGGESTS "elektra-doc, ${ALL_PLUGINS_STR}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXPERIMENTAL_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXTRA_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-EXTRA_DISPLAY_NAME}")
if ("${OS_NAME}" MATCHES "openSUSE")
	set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXTRA_PACKAGE_REQUIRES "glibc-locale")
endif ()
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXTRA_PACKAGE_SUGGESTS "elektra-doc, ${ALL_PLUGINS_STR}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-EXTRA_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-EXTRA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_ELEKTRA-BIN_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-BIN_DISPLAY_NAME}")
set (CPACK_RPM_ELEKTRA-BIN_PACKAGE_CONFLICTS "kernel-patch-kdb")
set (CPACK_RPM_ELEKTRA-BIN_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-BIN_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-BIN_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-BIN_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA-DEV_PACKAGE_NAME "libelektra-devel")
set (CPACK_RPM_LIBELEKTRA-DEV_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA-DEV_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA-DEV_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-AUGEAS_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-AUGEAS_DISPLAY_NAME}")
if ("${OS_NAME}" MATCHES "openSUSE")
	set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-AUGEAS_PACKAGE_REQUIRES "augeas-lenses")
endif ()
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-AUGEAS_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-AUGEAS_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-AUGEAS_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-AUGEAS_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-DBUS_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-DBUS_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-DBUS_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-DBUS_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-DBUS_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-DBUS_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ZEROMQ_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-ZEROMQ_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ZEROMQ_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-ZEROMQ_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ZEROMQ_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ZEROMQ_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XMLTOOL_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-XMLTOOL_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XMLTOOL_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-XMLTOOL_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XMLTOOL_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XMLTOOL_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XERCES_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-XERCES_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XERCES_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-XERCES_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XERCES_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-XERCES_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAJL_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-YAJL_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAJL_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-YAJL_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAJL_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAJL_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CRYPTO_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-CRYPTO_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CRYPTO_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-CRYPTO_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CRYPTO_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CRYPTO_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CURL_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-CURL_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CURL_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-CURL_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CURL_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-CURL_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JOURNALD_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-JOURNALD_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JOURNALD_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-JOURNALD_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JOURNALD_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JOURNALD_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-GITRESOLVER_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-GITRESOLVER_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-GITRESOLVER_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-GITRESOLVER_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-GITRESOLVER_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-GITRESOLVER_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAMLCPP_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-YAMLCPP_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAMLCPP_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-YAMLCPP_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAMLCPP_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-YAMLCPP_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-LUA_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-LUA_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-LUA_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-LUA_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-LUA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-LUA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JAVA_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-JAVA_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JAVA_PACKAGE_REQUIRES "java-11-openjdk-devel")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JAVA_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-JAVA_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JAVA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-JAVA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FUSE_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-FUSE_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FUSE_PACKAGE_REQUIRES "fuse, python3 >= 3.6")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FUSE_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-FUSE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FUSE_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-FUSE_DEBUGINFO_PACKAGE "OFF")

set (CPACK_RPM_JAVA-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_JAVA-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_JAVA-ELEKTRA_PACKAGE_REQUIRES "java-11-openjdk-devel")
set (CPACK_RPM_JAVA-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_JAVA-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_JAVA-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")

set (CPACK_RPM_LUA-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_LUA-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_LUA-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_LUA-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_LUA-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LUA-ELEKTRA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_PYTHON3-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_PYTHON3-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_PYTHON3-ELEKTRA_PACKAGE_REQUIRES "python3")
set (CPACK_RPM_PYTHON3-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_PYTHON3-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_PYTHON3-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_PYTHON3-ELEKTRA_DEBUGINFO_PACKAGE "OFF")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-PYTHON_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-PYTHON_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-PYTHON_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-PYTHON_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-PYTHON_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-PYTHON_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_RUBY-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_RUBY-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_RUBY-ELEKTRA_PACKAGE_REQUIRES "ruby")
set (CPACK_RPM_RUBY-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_RUBY-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_RUBY-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_RUBY-ELEKTRA_DEBUGINFO_PACKAGE "OFF")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-RUBY_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-RUBY_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-RUBY_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-RUBY_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-RUBY_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-RUBY_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_GLIB-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_GLIB-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_GLIB-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_GLIB-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_GLIB-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_GLIB-ELEKTRA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_IO-EV-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_IO-EV-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_IO-EV-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_IO-EV-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_IO-EV-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_IO-EV-ELEKTRA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_IO-GLIB-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_IO-GLIB-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_IO-GLIB-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_IO-GLIB-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_IO-GLIB-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_IO-GLIB-ELEKTRA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_IO-UV-ELEKTRA_PACKAGE_NAME "${CPACK_COMPONENT_IO-UV-ELEKTRA_DISPLAY_NAME}")
set (CPACK_RPM_IO-UV-ELEKTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_IO-UV-ELEKTRA_DESCRIPTION}")
set (CPACK_RPM_IO-UV-ELEKTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_IO-UV-ELEKTRA_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_ELEKTRA-BIN-EXTRA_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-BIN-EXTRA_DISPLAY_NAME}")
set (CPACK_RPM_ELEKTRA-BIN-EXTRA_PACKAGE_REQUIRES "python3")
set (CPACK_RPM_ELEKTRA-BIN-EXTRA_PACKAGE_CONFLICTS "${CPACK_COMPONENT_ELEKTRA-BIN_DISPLAY_NAME} < ${CPACK_RPM_PACKAGE_VERSION}")
set (CPACK_RPM_ELEKTRA-BIN-EXTRA_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-BIN-EXTRA_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-BIN-EXTRA_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-BIN-EXTRA_DEBUGINFO_PACKAGE "OFF")

set (CPACK_RPM_ELEKTRA-QT-GUI_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-QT-GUI_DISPLAY_NAME}")
if ("${OS_NAME}" MATCHES "openSUSE")
	set (CPACK_RPM_ELEKTRA-QT-GUI_PACKAGE_REQUIRES "libqt5-qtquickcontrols")
else ()
	set (CPACK_RPM_ELEKTRA-QT-GUI_PACKAGE_REQUIRES "qt5-qtquickcontrols")
endif ()
set (CPACK_RPM_ELEKTRA-QT-GUI_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-QT-GUI_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-QT-GUI_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-QT-GUI_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_ELEKTRA-TESTS_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-TESTS_DISPLAY_NAME}")
set (CPACK_RPM_ELEKTRA-TESTS_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-TESTS_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-TESTS_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-TESTS_DEBUGINFO_PACKAGE "${PACKAGE_DEBUGINFO}")

set (CPACK_RPM_ELEKTRA-DBG_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-DBG_DISPLAY_NAME}")
set (CPACK_RPM_ELEKTRA-DBG_PACKAGE_REQUIRES "${FEDORA_DBG_PACKAGE_NAMES_STR}")
set (CPACK_RPM_ELEKTRA-DBG_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-DBG_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-DBG_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")

set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ALL_PACKAGE_NAME "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-ALL_DISPLAY_NAME}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ALL_PACKAGE_REQUIRES ${LIBELEKTRA${SO_VERSION}-ALL_DEPENDS})
set (
	CPACK_RPM_LIBELEKTRA${SO_VERSION}-ALL_PACKAGE_RECOMMENDS
	"${CPACK_RPM_ELEKTRA-TESTS_PACKAGE_NAME}, ${CPACK_RPM_ELEKTRA-DOC_PACKAGE_NAME}, ${CPACK_RPM_ELEKTRA-DBG_PACKAGE_NAME}, ${CPACK_RPM_LIBELEKTRA-DEV_PACKAGE_NAME}"
)
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ALL_PACKAGE_SUMMARY "${CPACK_COMPONENT_LIBELEKTRA${SO_VERSION}-ALL_DESCRIPTION}")
set (CPACK_RPM_LIBELEKTRA${SO_VERSION}-ALL_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")

set (CPACK_RPM_ELEKTRA-MISC_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-MISC_DISPLAY_NAME}")
set (CPACK_RPM_ELEKTRA-MISC_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-MISC_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-MISC_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")

set (CPACK_RPM_ELEKTRA-DOC_PACKAGE_NAME "${CPACK_COMPONENT_ELEKTRA-DOC_DISPLAY_NAME}")
set (CPACK_RPM_ELEKTRA-DOC_PACKAGE_SUMMARY "${CPACK_COMPONENT_ELEKTRA-DOC_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-DOC_PACKAGE_DESCRIPTION "${PACKAGE_DESCRIPTION}")
set (CPACK_RPM_ELEKTRA-DOC_PACKAGE_ARCHITECTURE "noarch")
