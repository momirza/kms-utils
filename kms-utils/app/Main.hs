module Main where

import           Lib
import           Data.Text
import           Data.Text.Encoding
import           Data.Monoid
import           Data.Maybe
import           Options.Applicative


data Options = Encrypt {
    keyAlias :: String,
    plainText :: String
} | Decrypt deriving Show


options :: Parser Options
options =
    Encrypt
        <$> strOption
                (long "key-alias" <> metavar "key_alias" <> help
                    "Key alias in kms to use to encrypt. alias/{key_alis}"
                )
        <*> strOption
                (long "plaintext" <> metavar "plaintext" <> help
                    "Plaintext to encrypt"
                )


opts = subparser
    (  command
            "decrypt"
            (info
                (pure Decrypt)
                (fullDesc <> progDesc "CI utils to update variable" <> header
                    "update-variable - Update a variable in a given file."
                )
            )
    <> command
           "encrypt"
           (info options (progDesc "CI utils to update variable"))
    )


decryptStdin :: IO ()
decryptStdin = do
    input <- getContents
    pt    <- decryptLine (pack input)
    putStr $ unpack pt

run :: Options -> IO ()
run Decrypt         = decryptStdin
run (Encrypt ka pt) = do
    ct <- encryptPlainText ("alias/" ++ ka) pt
    putStr $ unpack $ Data.Text.Encoding.decodeUtf8 $ fromJust ct

main :: IO ()
main = execParser (info (opts <**> helper) idm) >>= run

