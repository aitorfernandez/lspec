describe("Task class", function()
    local task
    local func

    before(function()
        func = function()
            return 1 + 1
        end
    end)

    describe("Save and execute", function()
        before(function()
            task = Task.new(func)
        end)

        it("should save a function", function()
            expect(task.func):shouldBeType('function')
        end)

        it("should execute the function", function()
            expect(task:execute()):shouldBe(2)
        end)
    end)
end)
