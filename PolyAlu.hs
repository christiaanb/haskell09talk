{-# LINE 4 "PolyAlu.lhs" #-}
{-#  LANGUAGE  TypeOperators, TypeFamilies, FlexibleContexts  #-}
module Main where

import qualified Prelude as P
{-# LINE 29 "PolyAlu.lhs" #-}
import CLasH.HardwareTypes
{-# LINE 36 "PolyAlu.lhs" #-}
import CLasH.Translator.Annotations
{-# LINE 48 "PolyAlu.lhs" #-}
type Op s a         =   a -> Vector s a -> a
type Opcode         =   Bit
{-# LINE 56 "PolyAlu.lhs" #-}
type RegBank s a    =   Vector (s :+: D1) a
type RegState s a   =   State (RegBank s a)
{-# LINE 64 "PolyAlu.lhs" #-}
type Word           =   SizedInt D12
{-# LINE 76 "PolyAlu.lhs" #-}
primOp :: (a -> a -> a) -> Op s a
primOp f a b = a `f` a
{-# LINE 84 "PolyAlu.lhs" #-}
vectOp :: (a -> a -> a) -> Op s a
vectOp f a b = foldl f a b
{-# LINE 99 "PolyAlu.lhs" #-}
alu :: 
  Op s a -> 
  Op s a -> 
  Opcode -> a -> Vector s a -> a
alu op1 op2 Low    a b = op1 a b
alu op1 op2 High   a b = op2 a b
{-# LINE 118 "PolyAlu.lhs" #-}
registerBank :: 
  ((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) => (RegState s a) -> a -> RangedWord s ->
  RangedWord s -> Bit -> ((RegState s a), a )
  
registerBank (State mem) data_in rdaddr wraddr wrenable = 
  ((State mem'), data_out)
  where
    data_out  =   mem!rdaddr
    mem'  | wrenable == Low    = mem
          | otherwise          = replace mem wraddr data_in
{-# LINE 141 "PolyAlu.lhs" #-}
{-# ANN actual_cpu TopEntity#-}
actual_cpu :: 
  (Opcode, Word, Vector D4 Word, RangedWord D9, 
  RangedWord D9, Bit) ->  RegState D9 Word ->
  (RegState D9 Word, Word)

actual_cpu (opc, a ,b, rdaddr, wraddr, wren) ram = (ram', alu_out)
  where
    alu_out = alu (primOp (+)) (vectOp (+)) opc ram_out b
    (ram',ram_out)  = registerBank ram a rdaddr wraddr wren
{-# LINE 160 "PolyAlu.lhs" #-}
{-# ANN initstate InitState#-}
initstate :: RegState D9 Word
initstate = State (copy (0 :: Word))  
  
{-# ANN program TestInput#-}
program :: [(Opcode, Word, Vector D4 Word, RangedWord D9, RangedWord D9, Bit)]
program =
  [ (Low, 4, copy (0::Word), 0, 0, High) --  Write 4 to Reg0, out = 0
  , (Low, 3, copy (0::Word), 0, 1, High) --  Write 3 to Reg1, out = Reg0 + Reg0 = 8
  , (High,0, copy (3::Word), 1, 0, Low)  --  No Write       , out = 15
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
  let output = run actual_cpu istate input
  mapM_ (\x -> putStr $ ("# (" P.++ (show x) P.++ ")\n")) output
  return ()
