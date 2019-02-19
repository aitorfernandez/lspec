describe("Expectation class", function()
    local expectation
    local specResults
    local foo

    before(function()
        -- Reset specResults before spec
        specResults = SpecResults.new()
    end)

    describe("Be matchers", function()
        it("shouldBeTrue", function()
            foo = true
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeTrue()

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("shouldBeFalse", function()
            foo = false
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeFalse()

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("shouldBeNil", function()
            foo = nil
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeNil()

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("shouldBeLessThan", function()
            foo = 5
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeLessThan(10)

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("shouldBeGreaterThan", function()
            foo = 10
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeGreaterThan(5)

            expect(specResults.passedCount):shouldBe(1)
        end)
    end)

    describe("Equality matchers", function()
        it("shouldEqual", function()
            foo = true
            expectation = Expectation.new(foo, specResults)
            expectation:shouldEqual(true)

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("shouldBe", function()
            foo = 1
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBe(1)

            expect(specResults.passedCount):shouldBe(1)
        end)
    end)

    describe("Pattern-Matching", function()
        it("shouldMatch", function()
            foo = 'Lua rocks!'
            expectation = Expectation.new(foo, specResults)
            expectation:shouldMatch('Lua rocks!')

            expect(specResults.passedCount):shouldBe(1)
        end)
    end)

    describe("types", function()
        it("number", function()
            foo = 1
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeType('number')

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("string", function()
            foo = "I'm a string"
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeType('string')

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("boolean", function()
            foo = true
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeType('boolean')

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("table", function()
            foo = {}
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeType('table')

            expect(specResults.passedCount):shouldBe(1)
        end)

        it("function", function()
            foo = function() return true end
            expectation = Expectation.new(foo, specResults)
            expectation:shouldBeType('function')

            expect(specResults.passedCount):shouldBe(1)
        end)
    end)

    describe("Include matchers", function()
        it("shouldInclude", function()
            foo = { 1, 2, 3, 4, 5 }
            expectation = Expectation.new(foo, specResults)
            expectation:shouldInclude(1)

            expect(specResults.passedCount):shouldBe(1)
        end)
    end)


    --
    -- All expectations should works with the negation no
    --

    describe("Negations", function()

        describe("Negating Be matchers", function()
            it("no shouldBeTrue", function()
                foo = false
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeTrue()

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no shouldBeFalse", function()
                foo = true
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeFalse()

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no shouldBeNil", function()
                foo = 1
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeNil()

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no shouldBeLessThan", function()
                foo = 10
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeLessThan(5)

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no shouldBeGreaterThan", function()
                foo = 5
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeGreaterThan(10)

                expect(specResults.passedCount):shouldBe(1)
            end)
        end)

        describe("Negating Equality matchers", function()
            it("no shouldEqual", function()
                foo = false
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldEqual(true)

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no shouldBe", function()
                foo = 2
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBe(1)

                expect(specResults.passedCount):shouldBe(1)
            end)
        end)

        describe("Negating Pattern-Matching", function()
            it("no shouldMatch", function()
                foo = 'Lua rocks!'
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldMatch('PHP rocks!')

                expect(specResults.passedCount):shouldBe(1)
            end)
        end)

        describe("Negating types", function()
            it("no number", function()
                foo = "I'm a string"
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeType('number')

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no string", function()
                foo = 1
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeType('string')

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no boolean", function()
                foo = 1
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeType('boolean')

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no table", function()
                foo = true
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeType('table')

                expect(specResults.passedCount):shouldBe(1)
            end)

            it("no function", function()
                foo = {}
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldBeType('function')

                expect(specResults.passedCount):shouldBe(1)
            end)
        end)

        describe("Negating Include matchers", function()
            it("no shouldInclude", function()
                foo = { 1, 2, 3, 4, 5 }
                expectation = Expectation.new(foo, specResults)
                expectation:no():shouldInclude(6)

                expect(specResults.passedCount):shouldBe(1)
            end)
        end)
    end)
end)
