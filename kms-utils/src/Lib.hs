module Lib
    ( encryptPlainText
    , decryptCipherText
    )
where

import           Control.Lens
import           Control.Monad.IO.Class
import           Control.Monad.Trans.AWS
import           Data.ByteString         hiding ( pack )
import           Data.ByteString.Base64
import           Data.ByteString.Builder        ( hPutBuilder )
import           Data.Conduit
import qualified Data.Conduit.List             as CL
import           Data.Monoid
import           Data.Text
import           Data.Word
import           Network.AWS.Data
import           Network.AWS.KMS
import           System.IO


type PlainText = String
type KeyAlias = String
type RawCipherText = ByteString
type CipherText = ByteString

enc :: PlainText -> KeyAlias -> IO (Maybe RawCipherText)
enc pt ka = do
    env <- newEnv Discover
    let request = encrypt (pack ka) (toBS pt)
    runResourceT $ runAWST env $ within Ireland $ do
        resp <- send request
        return $ view ersCiphertextBlob resp

encryptPlainText :: PlainText -> KeyAlias -> IO (Maybe CipherText)
encryptPlainText pt ka = do
    ct <- enc pt ka
    return $ fmap encode ct

decryptCipherText :: CipherText -> IO PlainText
decryptCipherText = undefined
