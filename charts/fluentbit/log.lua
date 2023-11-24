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