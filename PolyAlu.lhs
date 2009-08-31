%include talk.fmt
%if style == newcode
\begin{code}
{-# LANGUAGE  TypeOperators, TypeFamilies, FlexibleContexts #-}
module Main where

import CLasH.HardwareTypes
import CLasH.Translator.Annotations
import qualified Prelude as P
\end{code}
%endif

\section{Polymorphic, Higher-Order CPU}
\subsection{Introduction}
\frame
{
\frametitle{Small Use Case}
\begin{columns}[l]
\column{0.5\textwidth}
\begin{figure}
\includegraphics[width=4.75cm]{simpleCPU}
\end{figure}
\column{0.5\textwidth}
\vspace{5em}
\begin{itemize}
  \item Polymorphic, Higher-Order CPU
  \item Use of state will be simple
\end{itemize}
\end{columns}
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
\begin{columns}[l]
\column{0.5\textwidth}
\begin{figure}
\includegraphics[width=4.75cm]{simpleCPU}
\end{figure}
\column{0.5\textwidth}
\vspace{2em}

First we define some ALU types:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type Op a         =   a -> a -> a
type Opcode       =   Bit
\end{code}
\end{beamercolorbox}\pause
\vspace{1em}
And some Register types:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
type RegBank s a    =   
  Vector (s :+: D1) a
type RegState s a   =   
  State (RegBank s a)
\end{code}
\end{beamercolorbox}
%if style == newcode
\begin{code}
type Word = SizedInt D12
\end{code}
%endif
\end{columns}
}\note[itemize]{
\item The ALU operation is already polymorphic in input / output type
\item We use a fixed size vector as the placeholder for the registers
\item State has to be of the State type to be recognized as such
}

\subsection{Polymorphic, Higher-Order ALU}
\frame
{
\frametitle{Simple ALU}
\begin{figure}
\includegraphics[width=5.25cm,trim=0mm 5.5cm 0mm 1cm, clip=true]{simpleCPU}
\end{figure}
Abstract ALU definition:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
alu :: 
  Op a -> Op a -> 
  Opcode -> a -> a -> a
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}Low{-"}"-}    a b = op1 a b
alu op1 op2 {-"{\color<2>[rgb]{1,0,0}"-}High{-"}"-}   a b = op2 a b
\end{code}
\end{beamercolorbox}
}\note[itemize]{
\item Alu is both higher-order, and polymorphic
\item First two parameters are "compile time", other three are "runtime"
\item We support pattern matching
}

\subsection{Register bank}
\frame
{
\frametitle{Register Bank}
\begin{figure}
\includegraphics[width=5.25cm,trim=0mm 0.4cm 0mm 6.2cm, clip=true]{simpleCPU}
\end{figure}
%if style == newcode
\begin{code}
registers :: 
  CXT((NaturalT s ,PositiveT (s :+: D1),((s :+: D1) :>: s) ~ True )) => a -> RangedWord s ->
  RangedWord s -> (RegState s a) -> (RegState s a, a )
\end{code}
%endif
A simple register bank:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
registers data_in rdaddr wraddr (State mem) = 
  ((State mem'), data_out)
  where
    data_out  = mem!rdaddr
    mem'      = replace mem wraddr data_in
\end{code}
\end{beamercolorbox}
}\note[itemize]{
\item mem is statefull, indicated by the 'State' type
\item replace and (!) are a builtin functions
}

\subsection{Simple CPU: ALU \& Register Bank}
\frame
{
\frametitle{Simple CPU}
Combining ALU and register bank:
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
%if style == newcode
\begin{code}
type Instruction = (Opcode, Word, RangedWord D9, RangedWord D9)
\end{code}
%endif
\begin{code}
{-"{\color<2>[rgb]{1,0,0}"-}ANN(cpu TopEntity){-"}"-}
cpu :: 
  Instruction -> RegState D9 Word -> (RegState D9 Word, Word)

cpu (opc, d, rdaddr, wraddr) ram = (ram', alu_out)
  where
    alu_out         = alu {-"{\color<3>[rgb]{1,0,0}"-}(+){-"}"-} {-"{\color<3>[rgb]{1,0,0}"-}(-){-"}"-} opc d ram_out
    (ram',ram_out)  = registers alu_out rdaddr wraddr ram
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item Annotation is used to indicate top-level component}
\uncover<3->{\item Instantiate actual operations}
\end{itemize}
}\note[itemize]{
\item We use the new Annotion functionality to indicate this is the top level. TopEntity is defined by us.
\item At this stage, both operations for the ALU are defined
\item No polymorphism or higher-order stuff is allowed at this level.
\item Functions must be specialized, and have primitives for input and output 
}

%if style == newcode
\begin{code}
ANN(initstate InitState)
initstate :: RegState D9 Word
initstate = State (copy (0 :: Word))  
  
ANN(program TestInput)
program :: [Instruction]
program =
  [ (Low, 4, 0, 0) -- Write 4   to Reg0
  , (Low, 3, 0, 1) -- Write 3+4 to Reg1
  , (High,8, 1, 2) -- Write 8-7 to Reg2
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
\end{code}
%endif
