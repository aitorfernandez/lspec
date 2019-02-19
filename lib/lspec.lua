local insert       = table.insert
local write        = io.write
local format, find = string.format, string.find
local clock        = os.clock

lspec = {
    version = {
        major = 1,
        minor = 0,
        build = 1
    },
    Queue = {

    },
    Suite = {

    },
    Task = {

    },
    PrettyPrinter = {

    },
    ExpectationResult = {

    },
    Expectation = {

    },
    Spec = {

    },
    SpecResults = {

    },
    Env = {

    }
}

do
    local Queue

    Queue = {}
    Queue.__index = Queue

    function Queue.new()
        local inst = {}
        setmetatable(inst, Queue)

        inst.name = "Queue"
        inst.tasks = {}

        return inst
    end

    function Queue:addFirst(task)
        insert(self.tasks, 1, task)
    end

    function Queue:add(task)
        insert(self.tasks, task)
    end

    function Queue:start()
        self:execute()
    end

    function Queue:execute()
        for _, task in ipairs(self.tasks) do
            task:execute()
        end
    end

    lspec.Queue = Queue
end

Queue = lspec.Queue


do
    local Suite

    Suite = {}
    Suite.__index = Suite

    function Suite.new(description, parentSuite)
        local inst = {}
        setmetatable(inst, Suite)

        inst.name = "Suite"

        inst.before = {}
        inst.after = {}

        inst.description = description
        inst.parentSuite = parentSuite

        return inst
    end

    function Suite:addBefore(func)
        insert(self.before, 1, func)
    end

    function Suite:addAfter(func)
        insert(self.after, 1, func)
    end

    lspec.Suite = Suite
end

Suite = lspec.Suite


do
    local Task

    Task = {}
    Task.__index = Task

    function Task.new(func)
        assert(func ~= nil, "func expected")

        local inst = {}
        setmetatable(inst, Task)

        inst.name = "Task"

        inst.func = func

        return inst
    end

    function Task:execute()
        return self.func()
    end

    lspec.Task = Task
end

Task = lspec.Task


do
    local PrettyPrinter

    PrettyPrinter = {}
    PrettyPrinter.__index = PrettyPrinter

    function PrettyPrinter.new()
        local inst = {}
        setmetatable(inst, PrettyPrinter)

        inst.name = "PrettyPrinter"

        inst.ansi = {
            red     = 31,
            green   = 32,
            yellow  = 33,
            blue    = 34,
            noColor = 0
        }

        return inst
    end

    function PrettyPrinter:greenDot()
        return self:consoleWrite('green', '.')
    end

    function PrettyPrinter:redF()
        return self:consoleWrite('red', 'F')
    end

    function PrettyPrinter:yellowP()
        return self:consoleWrite('yellowP', 'P')
    end

    function PrettyPrinter:resetColor()
        return write('\27[' .. self.ansi.noColor .. 'm')
    end

    function PrettyPrinter:formatMessageWithColor(message, color)
        return '\27[' .. self.ansi[color] .. 'm' .. message
    end

    function PrettyPrinter:consoleWrite(color, str)
        -- Used \27 to obtain the bash \033 ESC character
        return write('\27[' .. self.ansi[color] .. 'm' .. str)
    end

    lspec.PrettyPrinter = PrettyPrinter
end

PrettyPrinter = lspec.PrettyPrinter


do
    local ExpectationResult

    ExpectationResult = {}
    ExpectationResult.__index = ExpectationResult

    function ExpectationResult.new(result, message, currentValue, expected, none)
        local inst = {}
        setmetatable(inst, ExpectationResult)

        inst.name = "ExpectationResult"

        inst.result = result
        inst.message = message

        if none then
            inst.result = not result
            inst.message = "no "..message
        end

        inst.currentValue = format('%s', tostring(currentValue or ''))
        inst.expected = format('%s', tostring(expected or ''))

        return inst
    end

    function ExpectationResult:expectationInfo()
        return 'Failured/Error! Expected ' .. self.currentValue .. ' ' .. self.message .. ' ' .. self.expected .. '\n'
    end

    lspec.ExpectationResult = ExpectationResult
end

ExpectationResult = lspec.ExpectationResult


do
    local Expectation

    Expectation = {}
    Expectation.__index = Expectation

    function Expectation.new(value, specResults)
        local inst = {}
        setmetatable(inst, Expectation)

        inst.name = "Expectation"

        inst.value = value
        inst.specResults = specResults

        inst.none = false

        return inst
    end

    --
    -- Be matchers
    --

    function Expectation:shouldBeTrue()
        return self.specResults:addResult(self:calculate(true))
    end

    function Expectation:shouldBeFalse()
        return self.specResults:addResult(self:calculate(false))
    end

    function Expectation:shouldBeNil()
        return self.specResults:addResult(self:calculate(nil))
    end

    function Expectation:shouldBeLessThan(expected)
        return self.specResults:addResult(ExpectationResult.new(self.value < expected, 'should be less than', self.value, expected, self.none))
    end

    function Expectation:shouldBeGreaterThan(expected)
        return self.specResults:addResult(ExpectationResult.new(self.value > expected, 'should be greater than', self.value, expected, self.none))
    end

    --
    -- Equality matchers
    --

    function Expectation:shouldEqual(expected)
        return self.specResults:addResult(self:calculate(expected))
    end

    function Expectation:shouldBe(expected)
        return self.specResults:addResult(self:calculate(expected))
    end

    --
    -- Pattern-Matching
    --

    function Expectation:shouldMatch(pattern)
        local match = find(self.value, pattern)

        if match then
            match = true
        else
            match = false
        end

        return self.specResults:addResult(ExpectationResult.new(match, 'should match with', self.value, pattern, self.none))
    end

    -- types
    --
    -- number
    -- string
    -- boolean
    -- table
    -- function
    -- thread

    function Expectation:shouldBeType(expected)
        return self.specResults:addResult(ExpectationResult.new(type(self.value) == expected, 'should be type', self.value, expected, self.none))
    end

    --
    -- Include
    --

    function Expectation:shouldInclude(expected)
        local include = false

        for _, v in ipairs(self.value) do
            if v == expected then
                include = true
            end
        end

        return self.specResults:addResult(ExpectationResult.new(include, 'should include', self.value, expected, self.none))
    end

    function Expectation:no()
        self.none = true
        return self
    end


    function Expectation:calculate(expected)
        return ExpectationResult.new(self.value == expected, 'should be', self.value, expected, self.none)
    end

    lspec.Expectation = Expectation
end

Expectation = lspec.Expectation


do
    local Spec

    Spec = {}
    Spec.__index = Spec

    function Spec.new(suite, description, env)
        assert(suite ~= nil, "suite expected")

        local inst = {}
        setmetatable(inst, Spec)

        inst.name = "Spec"

        inst.suite = suite
        inst.queue = Queue.new()

        inst.specResults = env.specResults

        -- save the suite and spec description for the specResult class
        inst.specResults.currentlog = {
            suiteDesc = suite.description,
            specDesc = description
        }

        return inst
    end

    function Spec:expect(value)
        local expectation = Expectation.new(value, self.specResults)
        return expectation
    end

    function Spec:add(func)
        local task = Task.new(func)
        self.queue:add(task)
    end

    function Spec:execute()
        self:addHooksToQueue()
        self.queue:start()
    end

    function Spec:addHooksToQueue()
        local currentSuite = self.suite

        while currentSuite ~= nil do
            for _, func in ipairs(currentSuite.before) do
                self.queue:addFirst(Task.new(func))
            end

            for _, func in ipairs(currentSuite.after) do
                self.queue:add(Task.new(func))
            end

            currentSuite = currentSuite.parentSuite
        end
    end

    lspec.Spec = Spec
end

Spec = lspec.Spec


do
    local SpecResults

    SpecResults = {}
    SpecResults.__index = SpecResults

    function SpecResults.new()
        local inst = {}
        setmetatable(inst, SpecResults)

        inst.name = "SpecResults"

        inst.prettyPrinter = PrettyPrinter.new()

        inst.totalCount, inst.passedCount, inst.failedCount, inst.pendingCount = 0, 0, 0, 0

        inst.currentFile = nil

        inst.currentLog = {
            suiteDesc = "",
            specDesc  = ""
        }

        inst.currentSuiteDesc = ""

        inst.failedMessages = inst.prettyPrinter:formatMessageWithColor('\n\nFailed examples:\n\n', 'noColor')
        inst.pendingMessages = inst.prettyPrinter:formatMessageWithColor('\n\nPending:\n\n', 'noColor')

        inst.expectationMessage = nil

        inst.output = ""

        return inst
    end

    function SpecResults:addResult(expectationResult)
        self.totalCount = self.totalCount + 1

        if expectationResult.result then
            self.passedCount = self.passedCount + 1

            self.prettyPrinter:greenDot()
        else
            self.failedCount = self.failedCount + 1

            self.prettyPrinter:redF()

            self.expectationMessage = self.prettyPrinter:formatMessageWithColor(expectationResult:expectationInfo(), 'red')

            self:updateFailedMessage()
        end

        return self:updatedOutputMessage()
    end

    function SpecResults:addPending(message)
        self.pendingCount = self.pendingCount + 1

        self.prettyPrinter:yellowP()

        return self:updatePendingMessage(message)
    end

    function SpecResults:updateFailedMessage()
        local tempFailedMessage = self.prettyPrinter:formatMessageWithColor(self.failedCount .. ') ' ..
                                  self.currentlog.suiteDesc .. ' ' .. self.currentlog.specDesc, 'noColor')

        self.failedMessages = self.failedMessages .. tempFailedMessage .. ' -- ' ..
                              self.currentFile .. '\n' .. self.expectationMessage .. '\n'
    end

    function SpecResults:updatePendingMessage(message)
        local tempPendingMessage = self.prettyPrinter:formatMessageWithColor(self.pendingCount .. ') ' ..
                                   self.currentlog.suiteDesc .. ' ' .. message, 'yellow')

        self.pendingMessages = self.pendingMessages .. tempPendingMessage .. ' -- ' .. self.currentFile .. '\n\n'
    end

    function SpecResults:updatedOutputMessage()
        local currentSuite = self.currentlog and self.currentlog.suiteDesc or ""

        if self.currentSuiteDesc == currentSuite then
            currentSuite = ""
        else
            currentSuite = '\n\n' .. currentSuite
        end

        local tempOutPutMessage = currentSuite .. '\n' .. (self.currentlog and self.currentlog.specDesc or "")

        self.output = self.output .. tempOutPutMessage
        self.currentSuiteDesc = self.currentlog and self.currentlog.suiteDesc or ""
    end

    lspec.SpecResults = SpecResults
end

SpecResults = lspec.SpecResults


do
    local Env

    Env = {}
    Env.__index = Env

    function Env.new()
        local inst = {}
        setmetatable(inst, Env)

        inst.name = "Env"

        inst.startTime = clock()

        inst.specResults = SpecResults.new()
        inst.prettyPrinter = PrettyPrinter.new()

        return inst
    end

    function Env:runSpecs(specFiles)
        self.startTime = clock()

        for _, specFile in ipairs(specFiles) do
            write(specFile.name .. ' ')
        end

        write("\n")

        for _, specFile in ipairs(specFiles) do
            self:runSpecFile(specFile)
        end
    end

    function Env:runSpecFile(specFile)
        self.specResults.currentFile = specFile.path

        local f, message = loadfile(specFile.path)
        local succeed, message = pcall(f)

        if message then
            return self.prettyPrinter:consoleWrite('red', '\n' .. message)
        end
    end

    function Env:addPending(message)
        return self.specResults:addPending(message)
    end

    function Env:printResults(output)
        self.specResults.prettyPrinter:resetColor()

        local color = 'noColor'

        if self.specResults.failedCount ~= 0 then
            self:printFailedResults()
        end

        if self.specResults.pendingCount ~= 0 then
            self:printPendingResults()
        end

        write('\n')

        self.prettyPrinter:consoleWrite(color, '\nFinished in ' .. format('%.2f', clock() - self.startTime) .. ' seconds')

        if self.specResults.failedCount == 0 and self.specResults.pendingCount == 0 then
            color = 'green'
        else
            color = 'yellow'
        end

        local resumeResults = '\n' .. self.specResults.totalCount .. ' examples, '
                                   .. self.specResults.passedCount .. ' passed, '
                                   .. self.specResults.failedCount .. ' failures, '
                                   .. self.specResults.pendingCount .. ' pending'

        self.prettyPrinter:consoleWrite(color, resumeResults)

        write('\n')

        color = 'noColor'

        if output then
            return self.prettyPrinter:consoleWrite(color, self:printOutput())
        end
    end

    function Env:printFailedResults()
        return write(self.specResults.failedMessages)
    end

    function Env:printPendingResults()
        return write(self.specResults.pendingMessages)
    end

    function Env:printOutput()
        return '\n' .. self.specResults.currentFile .. '\n' .. self.specResults.output
    end

    lspec.Env = Env
end

Env = lspec.Env


currentSuite = nil
currentSpec = nil
environment = Env.new()

describe = function(description, specFunctions)
    local suite = Suite.new(description, currentSuite)
    local parentSuite = currentSuite

    currentSuite = suite

    specFunctions()

    currentSuite = parentSuite

    return suite
end

it = function(description, func)
    local spec = Spec.new(currentSuite, description, environment)

    currentSpec = spec

    spec:add(func)

    return spec:execute()
end

before = function(func)
    return currentSuite:addBefore(func)
end

after = function(func)
    return currentSuite:addAfter(func)
end

expect = function(value)
    return currentSpec:expect(value)
end

pending = function(description)
    return environment:addPending(description)
end
