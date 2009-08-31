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
\begin{itemize}
  \item Small Polymorphic, Higher-Order CPU\pause
  \item Each function is turned into a hardware component\pause
  \item Use of state will be simple
\end{itemize}
}\note[itemize]{
\item Small "toy"-example of what can be done in \clash{}
\item Show what can be translated to Hardware
\item Put your hardware glasses on: each function will be a component
\item Use of state will be kept simple
}

\frame
{
\frametitle{Imports}\pause
Import all the built-in types, such as vectors and integers:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
import CLasH.HardwareTypes
\end{code}
\end{beamercolorbox}\pause

Import annotations, helps \clash{} to find top-level component:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
import CLasH.Translator.Annotations
\end{code}
\end{beamercolorbox}
}\note[itemize]{
\item The first input is always needed, as it contains the builtin types
\item The second one is only needed if you want to make use of Annotations
}

\subsection{Type Definitions}
\frame
{
\frametitle{Type definitions}\pause
First we define some ALU types:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type Op s a         =   a -> Vector s a -> a
type Opcode         =   Bit
\end{code}
\end{beamercolorbox}\pause

And some Register types:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type RegBank s a    =   Vector (s :+: D1) a
type RegState s a   =   State (RegBank s a)
\end{code}
\end{beamercolorbox}\pause

And a simple Word type:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type Word           =   SizedInt D12
\end{code}
\end{beamercolorbox}
}\note[itemize]{
\item The first type is already polymorphic, both in size, and element type
\item It's a small example, so Opcode is just a Bit
\item State has to be of the State type to be recognized as such
\item SizedInt D12: One concrete type for now, to make the signatures smaller
}

\subsection{Frameworks for Operations}
\frame
{
\frametitle{Operations}\pause
We make a primitive operation:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
primOp :: {-"{\color<4>[rgb]{1,0,0}"-}(a -> a -> a){-"}"-} -> Op s a
primOp f a b = a `f` a
\end{code}
\end{beamercolorbox}\pause

We make a vector operation:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
vectOp :: {-"{\color<4>[rgb]{1,0,0}"-}(a -> a -> a){-"}"-} -> Op s a
vectOp f a b = {-"{\color<4>[rgb]{1,0,0}"-}foldl{-"}"-} f a b
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<4->{\item We support Higher-Order Functionality}
\end{itemize}
}\note[itemize]{
\item These are just frameworks for 'real' operations
\item Notice how they are High-Order functions
}

\subsection{Polymorphic, Higher-Order ALU}
\frame
{
\frametitle{Simple ALU}
We define a polymorphic ALU:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
alu :: 
  Op s a -> 
  Op s a -> 
  Opcode -> a -> Vector s a -> a
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}Low{-"}"-}    a b = op1 a b
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}High{-"}"-}   a b = op2 a b
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item We support Pattern Matching}
\end{itemize}
}\note[itemize]{
\item Alu is both higher-order, and polymorphic
\item We support pattern matching
}

\subsection{Register bank}
\frame
{
\frametitle{Register Bank}
Make a simple register bank:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
registerBank :: 
  CXT((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) => (RegState s a) -> a -> RangedWord s ->
  RangedWord s -> Bit -> ((RegState s a), a )
  
registerBank (State mem) data_in rdaddr wraddr wrenable = 
  ((State mem'), data_out)
  where
    data_out  =   mem!rdaddr
    mem'  {-"{\color<2>[rgb]{1,0,0}"-}| wrenable == Low{-"}"-}    = mem
          {-"{\color<2>[rgb]{1,0,0}"-}| otherwise{-"}"-}          = replace mem wraddr data_in
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item We support Guards}
\end{itemize}
}\note[itemize]{
\item RangedWord runs from 0 to the upper bound
\item mem is statefull
\item We support guards
}

\subsection{Simple CPU: ALU \& Register Bank}
\frame
{
\frametitle{Simple CPU}
Combining ALU and register bank:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
{-"{\color<2>[rgb]{1,0,0}"-}ANN(actual_cpu TopEntity){-"}"-}
actual_cpu :: 
  (Opcode, Word, Vector D4 Word, RangedWord D9, 
  RangedWord D9, Bit) ->  RegState D9 Word ->
  (RegState D9 Word, Word)

actual_cpu (opc, a ,b, rdaddr, wraddr, wren) ram = (ram', alu_out)
  where
    alu_out = alu ({-"{\color<3>[rgb]{1,0,0}"-}primOp (+){-"}"-}) ({-"{\color<3>[rgb]{1,0,0}"-}vectOp (+){-"}"-}) opc ram_out b
    (ram',ram_out)  = registerBank ram a rdaddr wraddr wren
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item Annotation is used to indicate top-level component}
\end{itemize}
}\note[itemize]{
\item We use the new Annotion functionality to indicate this is the top level
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