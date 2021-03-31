---
--- I'm 阿奇.
--- DateTime: 2021/3/31 16:49
---
--- @see http://www.faqs.org/rfcs/rfc5424.html
---

--- 日志错误级别 Log Severity Level
local SYSLOG_SEVERITY_EMERG     = 0       --  system is unusable
local SYSLOG_SEVERITY_ALERT     = 1       --  action must be taken immediately
local SYSLOG_SEVERITY_CRIT      = 2       --  critical conditions
local SYSLOG_SEVERITY_ERR       = 3       --  error conditions
local SYSLOG_SEVERITY_WARNING   = 4       --  warning conditions
local SYSLOG_SEVERITY_NOTICE    = 5       --  normal but significant condition
local SYSLOG_SEVERITY_INFO      = 6       --  informational
local SYSLOG_SEVERITY_DEBUG     = 7       --  debug-level messages

--- 日志
local SYSLOG_FACILITY_KERN      = 0       --  kernel messages
local SYSLOG_FACILITY_USER      = 1       --  random user-level messages
local SYSLOG_FACILITY_MAIL      = 2       --  mail system
local SYSLOG_FACILITY_DAEMON    = 3       --  system daemons
local SYSLOG_FACILITY_AUTH      = 4       --  security/authorization messages
local SYSLOG_FACILITY_SYSLOG    = 5       --  messages generated internally by syslogd
local SYSLOG_FACILITY_LPR       = 6       --  line printer subsystem
local SYSLOG_FACILITY_NEWS      = 7       --  network news subsystem
local SYSLOG_FACILITY_UUCP      = 8       --  UUCP subsystem
local SYSLOG_FACILITY_CRON      = 9       --  clock daemon
local SYSLOG_FACILITY_AUTHPRIV  = 10      --  security/authorization messages (private)
local SYSLOG_FACILITY_FTP       = 11      --  FTP daemon
local SYSLOG_FACILITY_LOCAL0    = 16      --  reserved for local use
local SYSLOG_FACILITY_LOCAL1    = 17      --  reserved for local use
local SYSLOG_FACILITY_LOCAL2    = 18      --  reserved for local use
local SYSLOG_FACILITY_LOCAL3    = 19      --  reserved for local use
local SYSLOG_FACILITY_LOCAL4    = 20      --  reserved for local use
local SYSLOG_FACILITY_LOCAL5    = 21      --  reserved for local use
local SYSLOG_FACILITY_LOCAL6    = 22      --  reserved for local use
local SYSLOG_FACILITY_LOCAL7    = 23      --  reserved for local use

local SEVERITY = {
    EMEGR   = SYSLOG_SEVERITY_EMERG,
    ALERT   = SYSLOG_SEVERITY_ALERT,
    CRIT    = SYSLOG_SEVERITY_CRIT,
    ERR     = SYSLOG_SEVERITY_ERR,
    WARNING = SYSLOG_SEVERITY_WARNING,
    NOTICE  = SYSLOG_SEVERITY_NOTICE,
    INFO    = SYSLOG_SEVERITY_INFO,
    DEBUG   = SYSLOG_SEVERITY_DEBUG,
}

local FACILITY = {
    KERN     = SYSLOG_FACILITY_KERN,
    USER     = SYSLOG_FACILITY_USER,
    MAIL     = SYSLOG_FACILITY_MAIL,
    DAEMON   = SYSLOG_FACILITY_DAEMON,
    AUTH     = SYSLOG_FACILITY_AUTH,
    SYSLOG   = SYSLOG_FACILITY_SYSLOG,
    LPR      = SYSLOG_FACILITY_LPR,
    NEWS     = SYSLOG_FACILITY_NEWS,
    UUCP     = SYSLOG_FACILITY_UUCP,
    CRON     = SYSLOG_FACILITY_CRON,
    AUTHPRIV = SYSLOG_FACILITY_AUTHPRIV,
    FTP      = SYSLOG_FACILITY_FTP,
    LOCAL0   = SYSLOG_FACILITY_LOCAL0,
    LOCAL1   = SYSLOG_FACILITY_LOCAL1,
    LOCAL2   = SYSLOG_FACILITY_LOCAL2,
    LOCAL3   = SYSLOG_FACILITY_LOCAL3,
    LOCAL4   = SYSLOG_FACILITY_LOCAL4,
    LOCAL5   = SYSLOG_FACILITY_LOCAL5,
    LOCAL6   = SYSLOG_FACILITY_LOCAL6,
    LOCAL7   = SYSLOG_FACILITY_LOCAL7,
}

local date = require("os").date
local syslog_date_format = "!%Y-%m-%dT%H:%M:%S.000Z"
local ngx = ngx

local _M = { version = 0.1 }

_M.output = function(facility, severity, hostname, app_name, pid, project,
               logstore, access_key_id, access_key_secret, msg)
    local pri = (FACILITY[facility] * 8 + SEVERITY[severity])
    ngx.update_time()
    local t = date(syslog_date_format, ngx.now())
    if not hostname then
        hostname = "-"
    end

    if not app_name then
        app_name = "-"
    end

    -- https://help.aliyun.com/document_detail/112903.html
    return "<" .. pri .. ">1 " .. t .. " " .. hostname .. " " .. app_name .. " " .. pid
            .. " - [logservice project=\"" .. project .. "\" logstore=\"" .. logstore
            .. "\" access-key-id=\"" .. access_key_id .. "\" access-key-secret=\""
            .. access_key_secret .. "\"] " .. msg .. "\n"
end

return _M