%include talk.fmt
%if style == newcode
\begin{code}
{-# LANGUAGE  TypeOperators, TypeFamilies, FlexibleContexts #-}
module PolyCPU where

import qualified Prelude as P
\end{code}
%endif

\section{Polymorphic, Higher-Order CPU}
\subsection{Introduction}
\frame
{
\frametitle{Small Use Case}
\begin{itemize}
  \item Small Polymorphic, Higher-Order CPU
  \item Each function is turned into a hardware component
  \item Use of state will be simple
\end{itemize}
}

\frame
{
\frametitle{Imports}
Import all the built-in types, such as vectors and integers:
\begin{code}
import CLasH.HardwareTypes
\end{code}\pause
Import annotations, helps \clash{} to find top-level component:
\begin{code}
import CLasH.Translator.Annotations
\end{code}
}

\subsection{Type Definitions}
\frame
{
First we define some ALU types:
\begin{code}
type Op s a         =   a -> Vector s a -> a
type Opcode         =   Bit
\end{code}\pause
And some Register types:
\begin{code}
type RegBank s a    =   Vector (s :+: D1) a
type RegState s a   =   State (RegBank s a)
\end{code}\pause
And a simple Word type:
\begin{code}
type Word           =   SizedInt D12
\end{code}
}
\subsection{Frameworks for Operations}
\frame
{
We make a primitive operation:
\begin{code}
primOp :: {-"{\color<3>[rgb]{1,0,0}"-}(a -> a -> a){-"}"-} -> Op s a
primOp f a b = a `f` a
\end{code}\pause
We make a vector operation:
\begin{code}
vectOp :: {-"{\color<3>[rgb]{1,0,0}"-}(a -> a -> a){-"}"-} -> Op s a
vectOp f a b = {-"{\color<3>[rgb]{1,0,0}"-}foldl{-"}"-} f a b
\end{code}
}
\subsection{Polymorphic, Higher-Order ALU}
\frame
{
We define a polymorphic ALU:
\begin{code}
alu :: 
  Op s a -> 
  Op s a -> 
  Opcode -> a -> Vector s a -> a
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}Low{-"}"-}    a b = op1 a b
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}High{-"}"-}   a b = op2 a b
\end{code}
}
\subsection{Register bank}
\frame
{
Make a simple register bank:
\begin{code}
registerBank :: 
  CXT((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) =>
  (RegState s a) -> a -> RangedWord s ->
  RangedWord s -> Bit -> ((RegState s a), a )
  
registerBank (State mem) data_in rdaddr wraddr wrenable = 
  ((State mem'), data_out)
  where
    data_out  =   mem!rdaddr
    mem'  {-"{\color<2>[rgb]{1,0,0}"-}| wrenable == Low{-"}"-}    = mem
          {-"{\color<2>[rgb]{1,0,0}"-}| otherwise{-"}"-}          = replace mem wraddr data_in
\end{code}
}
\subsection{Simple CPU: ALU \& Register Bank}
\frame
{
Combining ALU and register bank:
\begin{code}
{-"{\color<2>[rgb]{1,0,0}"-}ANN(actual_cpu TopEntity){-"}"-}
actual_cpu :: 
  (Opcode, Word, Vector D4 Word, RangedWord D9, 
  RangedWord D9, Bit) ->  RegState D9 Word ->
  (RegState D9 Word, Word)

actual_cpu (opc, a ,b, rdaddr, wraddr, wren) ram = 
  (ram', alu_out)
  where
    alu_out = alu simpleOp vectorOp opc ram_out b
    (ram',ram_out)  = registerBank ram a rdaddr wraddr wren
    simpleOp =  primOp  (+)
    vectorOp =  vectOp  (+)
\end{code}
}
