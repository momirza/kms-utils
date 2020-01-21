module Lib
    ( encryptPlainText
    , decryptLine
    )
where

import           Control.Lens
import           Control.Monad.IO.Class
import           Control.Monad.Trans.AWS
import           Data.ByteString         hiding ( pack )
import           Data.ByteString.Base64
import           Data.ByteString.Builder        ( hPutBuilder )
import           Data.ByteString.Lazy           ( toStrict )
import qualified Data.ByteString.Search        as BSS
import           Data.Conduit
import qualified Data.Conduit.List             as CL
import           Data.Monoid
import           Data.Text
import           Data.Text.Encoding
import           Network.AWS.Data
import           Network.AWS.KMS
import           Panic
import           Replace.Megaparsec
import           Text.Megaparsec
import           Text.Megaparsec.Char

type PlainText = String
type KeyAlias = String
type RawCipherText = ByteString
type CipherText = ByteString
type TaggedCipherText = ByteString

enc :: PlainText -> KeyAlias -> IO (Maybe RawCipherText)
enc pt ka = do
    env <- newEnv Discover
    let request = encrypt (pack ka) (toBS pt)
    runResourceT $ runAWST env $ within Ireland $ do
        resp <- send request
        return $ view ersCiphertextBlob resp

encryptPlainText ::  KeyAlias -> PlainText -> IO (Maybe CipherText)
encryptPlainText ka pt = do
    ct <- enc pt ka
    return $ fmap (tagCipherText . encode) ct

dec :: RawCipherText -> IO (Maybe ByteString)
dec ct = do
    env <- newEnv Discover
    let request = decrypt ct
    runResourceT $ runAWST env $ within Ireland $ do
        resp <- send request
        return $ view drsPlaintext resp

decryptCipherText :: CipherText -> Either String (IO (Maybe ByteString))
decryptCipherText ct = fmap dec (decode $ untagCipherText ct)

-- Isomorphic tagging

tagCipherText :: CipherText -> TaggedCipherText
tagCipherText = Data.ByteString.append "kmscrypt::"

untagCipherText :: TaggedCipherText -> CipherText
untagCipherText tct =
    toStrict $ BSS.replace "kmscrypt::" ("" :: ByteString) tct

decryptCipherTextOrPanic :: Text -> IO Text
decryptCipherTextOrPanic ct = case decryptCipherText (toBS ct) of
    Right mpt -> do
        pt <- mpt
        case pt of
            Just _pt -> return $ Data.Text.Encoding.decodeUtf8 _pt
            Nothing  -> panic "Failed to decrypt"
    Left _ -> panic "Failed to decrypt"

cipherText = do
    pre  <- chunk "kmscrypt::"
    post <- Data.Text.pack
        <$> some (alphaNumChar <|> char '+' <|> char '/' <|> char '=')
    return $ Data.Text.append pre post

decryptLine :: Text -> IO Text
decryptLine = streamEditT cipherText decryptCipherTextOrPanic
