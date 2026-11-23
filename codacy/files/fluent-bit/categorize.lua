-- Keep in sync with category() in images/support-bundle/support_bundle.py
local infrastructure = { postgres = true, postgresql = true, rabbitmq = true, rustfs = true, minio = true, redis = true,
  valkey = true, ["nfs-ganesha"] = true, nfs = true, ["fluent-bit"] = true, ["ingress-nginx"] = true, traefik = true }
local known = { infrastructure = true, services = true, workers = true, tools = true }

-- postgres, and also postgres-coverage, rabbitmq-ha and the like
local function is_infrastructure(app)
  for name, _ in pairs(infrastructure) do
    if app == name or string.sub(app, 1, #name + 1) == name .. "-" then return true end
  end
  return false
end

function categorize(tag, timestamp, record)
  local k = record["kubernetes"] or {}
  local labels = k["labels"] or {}
  local category = labels["codacy.com/log-category"]
  if not known[category] then
    local app = labels["app"] or labels["app.kubernetes.io/name"] or ""
    if app == "codacy-plugin" then category = "tools"
    elseif app == "worker" then category = "workers"
    elseif is_infrastructure(app) then category = "infrastructure"
    else category = "services" end
  end
  record["log_category"] = category
  record["pod_name"] = k["pod_name"] or "unknown"
  record["container_name"] = k["container_name"] or "unknown"
  return 2, timestamp, record
end
