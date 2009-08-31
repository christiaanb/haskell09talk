{-# LINE 4 "PolyAlu.lhs" #-}
{-#  LANGUAGE  TypeOperators, TypeFamilies, FlexibleContexts  #-}
module Main where

import CLasH.HardwareTypes
import CLasH.Translator.Annotations
import qualified Prelude as P
{-# LINE 51 "PolyAlu.lhs" #-}
type Op a         =   a -> a -> a
{-# LINE 58 "PolyAlu.lhs" #-}
type RegBank s a    =   
  Vector (s :+: D1) a
type RegState s a   =   
  State (RegBank s a)
{-# LINE 66 "PolyAlu.lhs" #-}
type Word = SizedInt D12
{-# LINE 85 "PolyAlu.lhs" #-}
type Opcode         =   Bit
alu :: 
  Op a -> Op a -> 
  Opcode -> a -> a -> a
alu op1 op2 Low    a b = op1 a b
alu op1 op2 High   a b = op2 a b
{-# LINE 108 "PolyAlu.lhs" #-}
registers :: 
  ((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) => a -> RangedWord s ->
  RangedWord s -> (RegState s a) -> (RegState s a, a )
{-# LINE 116 "PolyAlu.lhs" #-}
registers data_in rdaddr wraddr (State mem) = 
  ((State mem'), data_out)
  where
    data_out  = mem!rdaddr
    mem'      = replace mem wraddr data_in
{-# LINE 138 "PolyAlu.lhs" #-}
type Instruction = (Opcode, Word, RangedWord D9, RangedWord D9)
{-# LINE 142 "PolyAlu.lhs" #-}
{-# ANN cpu TopEntity#-}
cpu :: 
  Instruction -> RegState D9 Word -> (RegState D9 Word, Word)

cpu (opc, d, rdaddr, wraddr) ram = (ram', alu_out)
  where
    alu_out         = alu (+) (-) opc d ram_out
    (ram',ram_out)  = registers alu_out rdaddr wraddr ram
{-# LINE 165 "PolyAlu.lhs" #-}
{-# ANN initstate InitState#-}
initstate :: RegState D9 Word
initstate = State (copy (0 :: Word))  
  
{-# ANN program TestInput#-}
program :: [Instruction]
program =
  [ (Low, 4, 0, 0) --  Write 4   to Reg0
  , (Low, 3, 0, 1) --  Write 3+4 to Reg1
  , (High,8, 1, 2) --  Write 8-7 to Reg2
  ]

run func state [] = []
run func state (i:input) = o:out
  where
    (state', o) = func i state
    out         = run func state' input
    
main :: IO ()
main = do
  let input = program
  let istate = initstate
  let output = run cpu istate input
  mapM_ (\x -> putStr $ ("(" P.++ (show x) P.++ ")\n")) output
  return ()
