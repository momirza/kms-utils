module Lib
    ( encrypt
    ) where

data PlainText = PlainText String

data CipherText = CipherText String


encrypt :: PlainText ->  IO CipherText
encrypt = undefined 

