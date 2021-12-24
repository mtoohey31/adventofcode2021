<!-- cspell:ignore adventofcode neovim cout -->

# adventofcode2021

| Day | Language       | Prior Experience | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| --- | -------------- | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | C              | Almost none      | I still haven't gotten around to learning C yet, and while I'm sure it'll get harder once I have to deal with more complex data types, since I could perform the computation as I read the file, this was pretty painless!                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 2   | Go             | A little         | Go is pretty nice! There are only two things I can nitpick: the error messages aren't quite as nice as something like Rust, and I do miss some of the functional methods, though maybe there's a module that allows for those in Go. After using it for this day, I decided to use it in one of my personal projects, [gh-foreach](https://github.com/mtoohey31/gh-foreach).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| 3   | Dart           | A little         | It took me a surprising amount of time to figure out how to read a text file with Dart, but that's understandable since, from what I know, it's mainly used as part of Flutter for mobile development.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| 4   | Rust           | A lot            | I've used Rust a lot before, and I really like it. The code I wrote for this day was pretty messy though, it could probably be done far more elegantly. be                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 5   | Ruby           | None             | Ruby felt a lot like Python in many ways, though I prefer the syntax in some ways, and I yet again enjoyed the more functional methods, though I suppose these can be approximated by comprehensions in Python.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 6   | Clojure        | None             | This was the first language so far that I really felt was "something different". Since Clojure is a functional language, and I've never used a functional language before, it definitely took some adjusting to. My first few versions of a solution, while they worked, were pretty bad and non-functional, as in, though they worked, they were fighting against Clojure's functional nature instead of making use of it. This day probably took me the longest so far, and I've refactored the result multiple times.                                                                                                                                                                                                                                                                                                                                                                                            |
| 7   | F#             | None             | F# also has a lot of functional features, though it's nowhere near as purely functional as Clojure. Again, like Dart, it was surprisingly challenging to figure out how to read some text. F# doesn't really have the same excuse as Dart here, but it may just have been me. I feel like there are a lot of features of F# that I don't really understand; I have no prior experience with any .NET languages.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 8   | Fish           | A lot            | I've also used Fish a decent amount before. I lucked out in choosing it for this day, because it didn't end up requiring hash maps or anything like that. Even though Fish is just a shell, it's surprisingly elegant and functional for actual programming, as long as you're not using complex data types.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| 9   | R              | A medium amount  | R does some interesting things, like having operations apply element-wise to vectors and such. I've used it a decent amount in my university stats courses, and those features can be super handy for that kind of thing, but it was just a pain to use for standard programming. This day took me almost as long as day 6 with Clojure, and for that one I had to learn not only a completely new language, but also a whole new programming paradigm, whereas I've used R quite a bit before.                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 10  | Elixir         | None             | Now we're talking! I found Clojure really interesting, but I think it's just a little bit _too functional_, at least for my tastes. Elixir, at least in the way I used it for this problem, seemed like a very good happy medium. The map literal syntax is a little weird (though I prefer that to having to deal with `set()` in Python for creating empty sets because `{}` is taken by dicts), and I also found the requirement of having to define functions inside modules a little strange, there's probably a good reason for that though.                                                                                                                                                                                                                                                                                                                                                                  |
| 11  | Zig            | None             | I don't feel like this really gave me enough experience with Zig to be able to say much about it, I will say though, that it felt more approachable than C. However, since C is far more popular and mature, finding help online and documentation was significantly harder with Zig.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| 12  | Lua            | A medium amount  | I've used Lua before for Neovim configuration, it's insanely performant for an interpreted language, and I like the syntax as well, but it would be much more convenient if it contained more frequently used functions, for example, I had to write my own functions to check if a table contains a key or value for this task, which is the kind of thing that's a built in function in most other languages.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 13  | TypeScript     | A lot            | I've also used TypeScript a decent bit, this day was a bit of a cop-out for me since I was running low on time. I didn't learn anything more about TypeScript from this, but I can say from past experience that I prefer TypeScript to JavaScript when possible, if only for the better tooling with `tsserver` and its super helpful type-checking.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| 14  | Haskell        | None             | As functional languages go, I definitely prefer Haskell to Clojure, I'm not sure how I'd rank it compared to Elixir on first impressions. The syntax is somewhat friendly, but I found the function type declaration syntax somewhat confusing since everything is separated by `->`, so it's unclear as to where the arguments end and the return value begins, though it always has to be the final value so it's not really ambiguous. I really like the way the type `String` is literally equivalent to a list of characters, i.e. `[Char]`, though maybe the reason more languages don't do this is it causes unicode problems? I've only got part 1 of this day finished for now, I'll update this if I get part 2 done though.                                                                                                                                                                              |
| 15  | C#             | None             | I'd heard this before, and it rings pretty true after having used it, C# very similar to Java... The only material difference that came up while working on this day's problem was that C# has multidimensional arrays, though I'm sure there are many other important differences. Like I mentioned on the note for day 7, I'm not familiar with the .NET ecosystem. Also, I didn't really figure out the optimal solution to part 2, I brute forced it and it took about 5 minutes to run, but I'll update this if I come back to it and fix it.                                                                                                                                                                                                                                                                                                                                                                  |
| 16  | Kotlin         | None             | The tooling and syntax for Kotlin seem infinitely preferable to Java's. I especially like the `var` vs `val` mutable vs immutable declaration syntax, it feels familiar coming from Rust. I'm not sure how I feel about the array creation method such as `mutableListOf`, for example. I think in the future, if there's something I need to run on JVM and I just want things to be simple, Kotlin might be my first choice.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| 17  | C++            | None             | This day didn't really give me any reason to use any special C++ features, so using it was the same experience as using C, except I could use the string type and the `cout << ...` syntax for printing instead.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 18  | Erlang         | None             | I feel like this day's problem was much more well suited to a functional language. I found Erlang more cumbersome than Elixir, and its lack of strong typing was a double-edged sword compared to day 14 with Haskell. However, at the end of the day, it allowed me to implement a rather complex algorithm with a surprisingly small amount of code. I was also glad to discover that there was a way to parse the input by evaluating it as an expression since, although this method is not the most secure thing ever, for the purposes of this exercise, it's very convenient compared to trying to parse the nested list manually.                                                                                                                                                                                                                                                                           |
| 19  | Scala          | None             | I really liked Scala's mix of object-oriented and functional capabilities. I prefer Rust's `#[derive(PartialEq)]` method of specifying equality compared to Scala's `case class`, though maybe there's more differences there than I'm aware of. I'm also still not sure how I feel about languages that run in the JVM but aren't Java. If I had to pick between Clojure (the other JVM based functional language I've tried) and Scala, I'd definitely be Scala, not only because of it's object-oriented features, but also it's nicer syntax, and the fact that it feels less limited since it's not quite as purely functional as Clojure.                                                                                                                                                                                                                                                                     |
| 20  | Swift          | None             | Swift was... interesting. The syntax was pretty familiar and there weren't really any strange concepts, but the forced keyword arguments were a little annoying. The string indexing was also pretty strange (I suppose it's a valid solution to the somewhat tricky problem of unicode strings, but it would be nice if there was some shortcut syntax for plebs like me who just want the index without having to type 50 characters), and the index out of bounds error messages were truly frightening to behold. Pretty sure I brute forced part 2 again, it only took a minute to run though, so maybe the solution was good enough?                                                                                                                                                                                                                                                                          |
| 21  | AMD64 Assembly | None             | I've never dealt with x64 assembly before, but I have used MIPS a fair amount, so while it wasn't quite as much of a shock as it would've been if I'd had no assembly experience, x64 assembly has quite a few differences from MIPS. For instance, it didn't feel "register to register" in the same way MIPS does, and I'm used to having to supply 3 arguments for almost all operations: the destination, and two operands, whereas here the first operand is also the destination. All that being said, I'm somewhat happy with how far I got, I was able to complete part 1 purely in assembly, then I had to turn to Python for initial experimentation on part 2 since I wanted to be sure the algorithm was correct before trying to implement it in assembly. I got pretty for on turning it into assembly, but there are still a few bugs, so for now the only working implementation is the Python one. |
