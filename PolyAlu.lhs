%include talk.fmt
%if style == newcode
\begin{code}
{-# LANGUAGE  TypeOperators, TypeFamilies, FlexibleContexts #-}
module Main where

import qualified Prelude as P
\end{code}
%endif

\section{Polymorphic, Higher-Order CPU}
\subsection{Introduction}
\frame
{
\frametitle{Small Use Case}\pause
TODO: Plaatje
\begin{itemize}
  \item Polymorphic, Higher-Order CPU\pause
  \item Use of state will be simple
\end{itemize}
}\note[itemize]{
\item Small "toy"-example of what can be done in \clash{}
\item Show what can be translated to Hardware
\item Put your hardware glasses on: each function will be a component
\item Use of state will be kept simple
}

\subsection{Type Definitions}
\frame
{
\frametitle{Type definitions}\pause
TODO: Plaatje van de ALU
First we define some ALU types:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type Op a         =   a -> a -> a
\end{code}
\end{beamercolorbox}\pause

And some Register types:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type RegBank s a    =   Vector (s :+: D1) a
type RegState s a   =   State (RegBank s a)
\end{code}
\end{beamercolorbox}\pause
}\note[itemize]{
\item The first type is already polymorphic in input / output type
\item State has to be of the State type to be recognized as such
}

\subsection{Polymorphic, Higher-Order ALU}
\frame
{
\frametitle{Simple ALU}
Abstract ALU definition:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type Opcode         =   Bit
alu :: 
  Op a -> Op a -> 
  Opcode -> a -> a -> a
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}Low{-"}"-}    a b = op1 a b
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}High{-"}"-}   a b = op2 a b
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item We support Pattern Matching}
\end{itemize}
}\note[itemize]{
\item Alu is both higher-order, and polymorphic
\item Two parameters are "compile time", others are "runtime"
\item We support pattern matching
}

\subsection{Register bank}
\frame
{
\frametitle{Register Bank}
Make a simple register bank:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
TODO: Hide type sig
\begin{code}
registerBank :: 
  CXT((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) => a -> RangedWord s ->
  RangedWord s -> Bool -> (RegState s a) -> ((RegState s a), a )
  
registerBank data_in rdaddr wraddr (State mem) = 
  ((State mem'), data_out)
  where
    data_out  = mem!rdaddr
    mem'      = replace mem wraddr data_in
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item We support Guards}
\end{itemize}
}\note[itemize]{
\item RangedWord runs from 0 to the upper bound
\item mem is statefull
\item We support guards
\item replace is a builtin function
}

\subsection{Simple CPU: ALU \& Register Bank}
\frame
{
\frametitle{Simple CPU}
Combining ALU and register bank:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
TODO: Hide Instruction type?
\begin{code}
type Instruction = (Opcode, Word, RangedWord D9, RangedWord D9) ->  RegState D9 Word ->
{-"{\color<2>[rgb]{1,0,0}"-}ANN(actual_cpu TopEntity){-"}"-}
actual_cpu :: 
  Instruction -> RegState D9 Word -> (RegState D9 Word, Word)

actual_cpu (opc, d, rdaddr, wraddr) ram = (ram', alu_out)
  where
    alu_out = alu ({-"{\color<3>[rgb]{1,0,0}"-}(+){-"}"-}) ({-"{\color<3>[rgb]{1,0,0}"-}(-){-"}"-}) opc d ram_out
    (ram',ram_out)  = registerBank alu_out rdaddr wraddr ram
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item Annotation is used to indicate top-level component}
\end{itemize}
}\note[itemize]{
\item We use the new Annotion functionality to indicate this is the top level. TopEntity is defined by us.
\item the primOp and vectOp frameworks are now supplied with real functionality, the plus (+) operations
\item No polymorphism or higher-order stuff is allowed at this level.
\item Functions must be specialized, and have primitives for input and output 
}

%if style == newcode
\begin{code}
ANN(initstate InitState)
initstate :: RegState D9 Word
initstate = State (copy (0 :: Word))  
  
ANN(program TestInput)
program :: [(Opcode, Word, Vector D4 Word, RangedWord D9, RangedWord D9, Bit)]
program =
  [ (Low, 4, copy (0), 0, 0, High) -- Write 4 to Reg0, out = 0
  , (Low, 3, copy (0), 0, 1, High) -- Write 3 to Reg1, out = 8
  , (High,0, copy (3), 1, 0, Low)  -- No Write       , out = 15
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
  mapM_ (\x -> putStr $ ("(" P.++ (show x) P.++ ")\n")) output
  return ()
\end{code}
%endif
