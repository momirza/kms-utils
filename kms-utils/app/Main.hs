module Main where

import Lib
import Data.Text

main :: IO ()
main = do 
    mct <- encryptPlainText "alias/prod" "foo"
    case mct of 
        Just ct -> do
            print ct
            case decryptCipherText ct of
                Left error -> print error
                Right mpt -> do
                    pt <- mpt
                    print pt
        Nothing -> putStrLn  "Unable to encrypt"
