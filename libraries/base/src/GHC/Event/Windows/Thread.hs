{-# LANGUAGE NoImplicitPrelude #-}

module GHC.Event.Windows.Thread (
    ensureIOManagerIsRunning,
    interruptIOManager,
    threadDelay,
    registerDelay,
) where

import GHC.Conc.Sync
import GHC.Base
import GHC.Event.Windows
import GHC.IO
import GHC.IOPort

ensureIOManagerIsRunning :: IO ()
ensureIOManagerIsRunning = wakeupIOManager

interruptIOManager :: IO ()
interruptIOManager = interruptSystemManager

-- | Be careful not to exceed @maxBound :: Int@, which on 32-bit machines is only
-- 2147483647 μs, less than 36 minutes.
threadDelay :: Int -> IO ()
threadDelay usecs = mask_ $ do
    m <- newEmptyIOPort
    mgr <- getSystemManager
    reg <- registerTimeout mgr usecs $ writeIOPort m () >> return ()
    readIOPort m `onException` unregisterTimeout mgr reg

-- | Be careful not to exceed @maxBound :: Int@, which on 32-bit machines is only
-- 2147483647 μs, less than 36 minutes.
registerDelay :: Int -> IO (TVar Bool)
registerDelay usecs = do
    t <- newTVarIO False
    mgr <- getSystemManager
    _ <- registerTimeout mgr usecs $ atomically $ writeTVar t True
    return t

