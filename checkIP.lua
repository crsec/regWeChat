function isIPAvailable(IPforChecking)
	local sz = require("sz");
    local http = require("szocket.http");
	local response_body = {};
	local url = "http://119.23.142.95:7001/card-pool-api/ip";
	local data = "{\"data\":" .. IPforChecking .. ",\"method\":\"add\"}";
	require("TSLib");
	local result = httpPost(url, data);
	if (type(result) ~= "string") then
		return false;
	end
	local resultStr = result:base64_decode();
	local resultTable = sz.json.decode(resultStr);
	return resultTable.success;
end