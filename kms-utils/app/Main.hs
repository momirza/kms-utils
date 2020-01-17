module Main where

import Lib
import Data.Text.Encoding


main :: IO ()
main = do 
    mct <- encryptPlainText "alias/prod" $ Prelude.replicate 100 '1'
    case mct of 
        Just ct -> do
            print ct
            pt <- decryptLine $ Data.Text.Encoding.decodeUtf8 ct
            print pt
        Nothing -> putStrLn  "Unable to encrypt"
