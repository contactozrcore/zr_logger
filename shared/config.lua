return {
    -- Enable or disable the logging system.
    -- When set to true, the system will actively record and monitor events for any suspicious behavior.
    -- It is advisable to keep this enabled in production environments for security monitoring.
    EnableLogger = true,

    -- Maximum allowed size (in bytes) for the values contained in StateBags.
    -- Any StateBag value exceeding this threshold will be flagged as potentially malicious.
    maxStateBagPayload = 1500,

    -- Maximum allowed payload size (in bytes) for events.
    -- If an event's payload size exceeds this limit, it will be considered a potential security threat.
    maxEventPayload = 4000,

    -- Threshold (in bytes) for logging StateBag details.
    -- If the payload size is greater than this value but less than maxStateBagPayload,
    -- the event will be logged as informational without triggering a suspicious flag.
    maxLogStateBagPayload = 300,

    -- A list of event identifiers that should be excluded from logging and security checks.
    -- Events specified here will not be processed by the logging system.
    ignoreEvents = {
        '__cfx_internal:httpResponse'  -- This is an internal FiveM event and is generally considered secure.
    }
}