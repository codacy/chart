-- Masks session cookies and credentials in container logs before they reach the logs bucket.
-- Keep in sync with _REDACTIONS in images/support-bundle/support_bundle.py (codacy-self-hosted), which masks bundles too.

-- "cookie" -> "[Cc][Oo][Oo][Kk][Ii][Ee]": Lua patterns have no case-insensitive flag
local function anycase(word)
  return (word:gsub("%a", function(c) return "[" .. c:upper() .. c:lower() .. "]" end))
end

local VALUE = "[^;%s,%)\"']+"
local rules = {}
local function rule(pattern, replacement) rules[#rules + 1] = { pattern, replacement } end

-- Cookie and Authorization headers however a log writes them: "Cookie: ...", "Cookie -> List(...)", "cookie": "..."
for _, header in ipairs({ "cookie", "authorization" }) do
  rule("(" .. anycase(header) .. "%s*%->%s*List%()[^)\n]*", "%1[REDACTED]")
  rule("(" .. anycase(header) .. "[\"']?%s*[:=]%s*[\"']?)[^\n\"']+", "%1[REDACTED]")
end
rule("(" .. anycase("bearer") .. "%s+)[%w%._~%+/=%-]+", "%1[REDACTED]")
-- Session cookies wherever they appear
for _, name in ipairs({ "_sessiondata", "PLAY_SESSION", "PLAY_FLASH", "PLAY_CSRF_TOKEN", "JSESSIONID", "codacy%.login%.token" }) do
  rule("(" .. name .. "=)" .. VALUE, "%1[REDACTED]")
end
-- Codacy API and project tokens in headers and query strings
for _, name in ipairs({ "api", "project" }) do
  rule("(" .. anycase(name) .. "[_%-]" .. anycase("token") .. "[\"']?%s*[:=]%s*[\"']?)[^&%s\"',;%)]+", "%1[REDACTED]")
end
-- Provider tokens and AWS keys (Lua has no alternation or {n}: one rule per prefix, repeated classes)
rule("gh[pousr]_" .. string.rep("%w", 16) .. "%w*", "[REDACTED]")
rule("github_pat_" .. string.rep("[%w_]", 20) .. "[%w_]*", "[REDACTED]")
for _, prefix in ipairs({ "glpat", "gloas", "glrt", "glptt" }) do
  rule(prefix .. "%-" .. string.rep("[%w_%-]", 20) .. "[%w_%-]*", "[REDACTED]")
end
rule("AKIA" .. string.rep("[%u%d]", 16), "[REDACTED]")

function redact(tag, timestamp, record)
  local line = record["log"]
  if type(line) ~= "string" then return 0, timestamp, record end
  local masked = line
  for _, r in ipairs(rules) do masked = masked:gsub(r[1], r[2]) end
  if masked == line then return 0, timestamp, record end
  record["log"] = masked
  return 2, timestamp, record
end
