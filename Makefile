.PHONY: package

CMDB_USER_NAME:=xxx
CMDB_PASSWORD:=xxx
package:
	bash ./generate-yaml.sh cmdbUsername=${CMDB_USER_NAME} cmdbPassword=${CMDB_PASSWORD}
