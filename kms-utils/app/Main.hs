module Main where

import Lib
import Data.Text

main :: IO ()
main = do 
    mct <- encryptPlainText "alias/prod" "foo"
    case mct of 
        Just ct -> print ct
        Nothing -> putStrLn  "Unable to encrypt"
