function rewrite_tag(tag, timestamp, record)
    if tag == "containerlog" and record ~= nil then
        if record["k8s/labels/DBBranch"] and string.match(record["k8s/labels/DBBranch"], "mssql.+") and record["container"] and record["container"] == "mssql" then
            tag = "mssql-log"
        elseif record["k8s/labels/app.kubernetes.io/managed-by"] and record["k8s/labels/app.kubernetes.io/managed-by"] == "tidb-operator" then
            tag = "tidb-log"
        elseif  record["k8s/labels/ProxyType"] and record["k8s/labels/ProxyType"] == "maxscale" then
            tag = "maxscale-log"
        elseif  record["k8s/labels/DBType"] and record["k8s/labels/DBType"] == "kafka" and record["container"] and record["container"] == "kafka" then
            tag = "kafka-log"
        end
    end
    if tag == "mssql-auditlog" and record ~= nil then
        record["appName"] = record["cluster_name"]
        record["podName"] = string.format("%s-0", record["instance_name"])
        record["podNamespace"] = record["mssql/namespace"]
    end
    new_tag = string.format("qfrds-%s", tag)
    if string.match(tag, ".*auditlog.*") and record ~= nil and record["appName"] ~= nil and string.len(record["appName"]) > 0 then
    new_tag = string.format("%s-%s", new_tag, record["appName"])
    end
    record["tag"] = new_tag
    return 2, timestamp, record
end


r1 = { a = "b", c = "d", appName = "containerlog", container="mssql"}
r1["k8s/labels/DBBranch"] = "mssql2017"
_, _, r11 = rewrite_tag("containerlog", 343, r1)
print(r11["tag"])

r2 = { a = "b", c = "d", appName = "containerlog", container="kafka"}
r2["k8s/labels/DBType"] = "kafka"
_, _, r22 = rewrite_tag("containerlog", 343, r2)
print(r22["tag"])

r3 = { a = "b", c = "d", appName = "containerlog"}
r3["k8s/labels/app.kubernetes.io/managed-by"] = "tidb-operator"
_, _, r33 = rewrite_tag("containerlog", 343, r3)
print(r33["tag"])

r4 = { a = "b", c = "d", appName = "containerlog"}
r4["k8s/labels/ProxyType"] = "maxscale"
_, _, r44 = rewrite_tag("containerlog", 343, r4)
print(r44["tag"])

r5 = { a = "b", c = "d", appName = "testlog"}
_, _, r55 = rewrite_tag("mysql-auditlog", 343, r4)
print(r55["tag"])

r6 = { a = "b", c = "d", appName = "testlog", cluster_name="mssql-abcd", instance_name="mssql-abcd00"}
r6["mssql/namespace"] = "qfusion-admin"
_, _, r66 = rewrite_tag("mssql-auditlog", 343, r6)
print(r66["tag"])