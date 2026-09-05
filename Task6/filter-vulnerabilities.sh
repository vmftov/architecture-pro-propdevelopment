#!/bin/bash

# 1. Проверка на события доступа к secrets:

jq 'select(.objectRef.resource=="secrets" and .verb=="get")' audit.log

# 2. Проверка на kubectl exec в чужие поды:

jq 'select(.verb=="create" and .objectRef.subresource=="exec")' audit.log

# 3. Привилегированные поды:

jq 'select(.objectRef.resource=="pods" and .requestObject.spec.containers[].securityContext.privileged==true)' audit.log

# 4. Удаление или изменение audit policy:

grep -i 'audit-policy' audit.log

###

# 5. Изменение policies:

jq 'select((.verb == "create" or .verb == "update" or .verb == "patch" or .verb == "delete") and .objectRef.resource == "policies")' audit.log

# 6. Повышение пользователей до админа:

jq 'select((.verb == "create" or .verb == "update" or .verb == "patch") and .objectRef.resource == "rolebindings" and .requestObject.roleRef.name == "cluster-admin")' audit.log
