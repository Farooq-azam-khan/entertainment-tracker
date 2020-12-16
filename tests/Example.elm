module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

-- todo "Implement our first test. See https://package.elm-lang.org/packages/elm-explorations/test/latest for how to do this!"

suite : Test
suite = describe "The First Test Fail" 
[
    test "reverse string" <| \_ -> let
        palindrome = "haha"
    in
    Expect.equal palindrome (String.reverse palindrome)
    
]
