# lSpec

## Description

A LUA prototype based on [rspec](http://rspec.info/) for a Behaviour Driven Development testing framework.

## Use

```lua

describe("Something", function()
  local foo = 0

  before(function()
    foo = foo + 1
  end)

  describe("in one suite", function()
    before(function()
      foo = foo + 99 + 1
    end)

    it("spec the correct value", function()
      expect(foo):shouldBe(101)
    end)
  end)

  describe("in another suite", function()
    before(function()
      foo = foo + 1
    end)

    it("spec the correct value for this suite", function()
      expect(foo):shouldBe(2)
    end)
  end)
end)

```


## Expectations

```lua

describe("Expectations", function()

  describe("Be matchers", function()
    it("shouldBeTrue", function()
      expect(true):shouldBeTrue()
    end)

    it("shouldBeFalse", function()
      expect(false):shouldBeFalse()
    end)

    it("shouldBeNil", function()
      expect(nil):shouldBeNil()
    end)

    it("shouldBeLessThan", function()
      expect(5):shouldBeLessThan(10)
    end)

    it("shouldBeGreaterThan", function()
      expect(10):shouldBeGreaterThan(5)
    end)
  end)

  describe("Equality matchers", function()
    it("shouldEqual", function()
      expect(true):shouldEqual(true)
    end)

    it("shouldBe", function()
      expect(1):shouldBe(1)
    end)
  end)

  describe("Pattern-Matching", function()
    it("shouldMatch", function()
      expect('Lua rocks!'):shouldMatch('Lua rocks!')
    end)
  end)

  describe("types", function()
    it("number", function()
      expect(1):shouldBeType('number')
    end)

    it("string", function()
      expect("I'm a string"):shouldBeType('string')
    end)

    it("boolean", function()
      expect(true):shouldBeType('boolean')
    end)

    it("table", function()
      expect({}):shouldBeType('table')
    end)

    it("function", function()
      local foo = function() return true end
      expect(foo):shouldBeType('function')
    end)

  end)

  describe("Include matchers", function()
    it("shouldInclude", function()
      local foo = { 1, 2, 3, 4, 5 }
      expect(foo):shouldInclude(1)
    end)
  end)

  --
  -- All expectations works with the negation no
  --

  describe("Negating Be matchers", function()
    it("no shouldBeTrue", function()
      expect(false):no():shouldBeTrue()
    end)

    it("no shouldBeFalse", function()
      expect(true):no():shouldBeFalse()
    end)

    it("no shouldBeNil", function()
      expect(1):no():shouldBeNil()
    end)

    it("no shouldBeLessThan", function()
      expect(10):no():shouldBeLessThan(5)
    end)

    it("no shouldBeGreaterThan", function()
      expect(5):no():shouldBeGreaterThan(10)
    end)
  end)

  describe("Negating Equality matchers", function()
    it("no shouldEqual", function()
      expect(false):no():shouldEqual(true)
    end)

    it("no shouldBe", function()
      expect(2):no():shouldBe(1)
    end)
  end)

  describe("Negating Pattern-Matching", function()
    it("no shouldMatch", function()
      expect('Lua rocks!'):no():shouldMatch('PHP rocks!')
    end)
  end)

  describe("Negating types", function()
    it("no number", function()
      expect("I'm a string"):no():shouldBeType('number')
    end)

    it("no string", function()
      expect(1):no():shouldBeType('string')
    end)

    it("no boolean", function()
      expect(nil):no():shouldBeType('boolean')
    end)

    it("no table", function()
      expect(1):no():shouldBeType('table')
    end)

    it("no function", function()
      expect(1):no():shouldBeType('function')
    end)

  end)

  describe("Negating Include matchers", function()
    it("no shouldInclude", function()
      local foo = { 1, 2, 3, 4, 5 }
      expect(foo):no():shouldInclude(6)
    end)
  end)

end)

```

## specs

The next command runs the specs for the lspec lib.

```
$ lua lspec
```
