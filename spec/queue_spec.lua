describe("Queue class", function()
    local queue

    before(function()
        queue = Queue.new()
    end)

    it("should have a default tasks table", function()
        expect(queue.tasks):shouldBeType('table')
    end)

    describe("add queue funtions", function()
        before(function()
            queue.tasks = {1, 2, 3, 4}
        end)

        it("addFirst function should insert in first position", function()
            queue:addFirst(99)
            expect(queue.tasks[1]):shouldBe(99)
        end)

        it("add funtion should insert in the end position", function()
            queue:add(5)
            expect(queue.tasks[#queue.tasks]):shouldBe(5)
        end)
    end)
end)
