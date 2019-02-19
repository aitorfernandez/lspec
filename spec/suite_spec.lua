describe("Suite class", function()
    local suite

    before(function()
        suite = Suite.new("Something")
    end)

    describe("before table", function()
        before(function()
            suite:addBefore(1)
        end)

        it("should have a correct type", function()
            expect(suite.before):shouldBeType('table')
        end)

        it("addBefore function should insert in the correct table", function()
            expect(#suite.before):shouldBe(1)
        end)

        it("addAfter function should be empty when you insert in addBefore", function()
            expect(#suite.after):shouldBe(0)
        end)
    end)

    describe("after table", function()
        it("should have a correct type", function()
            expect(suite.after):shouldBeType('table')
        end)

        it("addAfter function should insert in the correct table", function()
            local values = { 1, 2, 3, 4, 5 }
            for _, v in ipairs(values) do
                suite:addAfter(v)
            end

            expect(#suite.after):shouldBe(5)
        end)

        it("addBefore function should be empty when you insert in addAfter", function()
            suite:addAfter(1)
            expect(#suite.before):shouldBe(0)
        end)
    end)

    describe("should have a values for description and parentSuite", function()
        it("should have a correct description", function()
            expect(suite.description):shouldBe('Something')
        end)

        it("should have nil if not have parent suite", function()
            expect(suite.parentSuite):shouldBeNil()
        end)

        describe("A valid parent suite", function()
            local childSuite

            before(function()
                childSuite = Suite.new("Something new", suite)
            end)

            it("should have a correct type parent suite", function()
                expect(childSuite.name):shouldBe('Suite')
            end)
        end)
    end)
end)
