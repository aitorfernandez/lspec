require 'lib.lspec'

local specFiles = {}

local specFolfer = assert(io.popen ("ls ./spec/*_spec.lua"))

for specFile in specFolfer:lines() do

    local t = {}

    for str in string.gmatch(specFile, "([^/]+)") do
        table.insert(t, str)
    end

    table.insert(specFiles, { name = t[#t], path = specFile })
end

specFolfer:close()

environment:runSpecs(specFiles)
environment:printResults(arg[1])
