module Main where

import System.Environment (getArgs)
import qualified Data.ByteString.Char8 as B
import Data.List
import Data.Ord
import Text.Printf
import System.CPUTime

time :: IO t -> IO t
time a = do
        start <- getCPUTime
        v <- a
        end   <- getCPUTime
        let diff = (fromIntegral (end - start)) / (10^12)
        printf "Query Took %.2f seconds\n" (diff :: Double)
        return v

read_stats fname = do
        x <- B.readFile fname
        let y = map (\y->if length y > 0 then (y!!0, y!!1, to_int (y!!2)) else (B.empty, B.empty, 0)) $ map (B.split ' ') $ B.split '\n' x
        return y

to_int x = case B.readInt x of
            Nothing -> 0
            Just (y,_) -> y

filter_stats = filter (\(a,b,c)->a == (B.pack "en") && c > 500)

print_status :: [(B.ByteString, B.ByteString, Int)] -> IO ()
print_status = mapM_ (\(_,x,y)->printf "%s (%d)\n" (B.unpack x) y)

do_stats fname = do
        xs <- read_stats fname
        return $! take 10 $ reverse $ sortBy (comparing (\(_,_,n)->n)) $ filter_stats xs

main = do
        argv <- getArgs
        ys <- time $ do_stats (argv!!0)
        print_status ys
