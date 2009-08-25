{-# LINE 4 "PolyAlu.lhs" #-}
{-#  LANGUAGE  TypeOperators, TypeFamilies, FlexibleContexts  #-}
module PolyCPU where

import qualified Prelude as P
{-# LINE 27 "PolyAlu.lhs" #-}
import CLasH.HardwareTypes
import CLasH.Translator.Annotations
{-# LINE 37 "PolyAlu.lhs" #-}
type Op s a         =   a -> Vector s a -> a
type Opcode         =   Bit
{-# LINE 42 "PolyAlu.lhs" #-}
type RegBank s a    =   Vector (s :+: D1) a
type RegState s a   =   State (RegBank s a)
{-# LINE 47 "PolyAlu.lhs" #-}
type Word           =   SizedInt D12
{-# LINE 55 "PolyAlu.lhs" #-}
primOp :: (a -> a -> a) -> Op s a
primOp f a b = a `f` a
{-# LINE 60 "PolyAlu.lhs" #-}
vectOp :: (a -> a -> a) -> Op s a
vectOp f a b = foldl f a b
{-# LINE 69 "PolyAlu.lhs" #-}
alu :: 
  Op s a -> 
  Op s a -> 
  Opcode -> a -> Vector s a -> a
alu op1 op2 Low    a b = op1 a b
alu op1 op2 High   a b = op2 a b
{-# LINE 82 "PolyAlu.lhs" #-}
registerBank :: 
  ((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) =>
  (RegState s a) -> a -> RangedWord s ->
  RangedWord s -> Bit -> ((RegState s a), a )
  
registerBank (State mem) data_in rdaddr wraddr wrenable = 
  ((State mem'), data_out)
  where
    data_out  =   mem!rdaddr
    mem'          | wrenable == Low  = mem
                  | otherwise        = replace mem wraddr data_in
{-# LINE 100 "PolyAlu.lhs" #-}
{-# ANN actual_cpu TopEntity#-}
actual_cpu :: 
  (Opcode, Word, Vector D4 Word, 
  RangedWord D9, 
  RangedWord D9, Bit) -> 
  RegState D9 Word ->
  (RegState D9 Word, Word)

actual_cpu (opc, a ,b, rdaddr, wraddr, wren) ram = (ram', alu_out)
  where
    alu_out = alu simpleOp vectorOp opc ram_out b
    (ram',ram_out)  = registerBank ram a rdaddr wraddr wren
    simpleOp =  primOp  (+)
    vectorOp =  vectOp  (+)
