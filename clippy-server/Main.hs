{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Clippy.ES                            (insertSnippet',
                                                       insertYank',
                                                       searchSnippet',
                                                       searchYank')
import           Control.Monad.Trans                  (liftIO)
import           Data.Aeson                           hiding (json)
import           Network.Wai.Middleware.RequestLogger
import           Web.Scotty

main :: IO ()
main =
  scotty 3000 $ do
    middleware logStdoutDev
    get "/" $
      json $ object ["yank_url" .= String "/yanks",
                     "snippet_url" .= String "/snippets"]
    post "/yanks" $
      json . show =<< liftIO . insertYank' =<< jsonData
    post "/yanks/search" $
      json =<< liftIO . searchYank' =<< jsonData

    post "/snippets" $
      json . show =<< liftIO . insertSnippet' =<< jsonData
    post "/snippets/search" $
      json =<< liftIO . searchSnippet' =<< jsonData
