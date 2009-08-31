%include talk.fmt
\section{Conclusion}

\frame{
\frametitle{Some final words}
\begin{itemize}
  \item Still a lot to do: translate larger subset of Haskell
  \item Real world prototype designs can already be made in \clash{}
%  \item \clash{} is another great example of how to bring functional expressivity to hardware designs
\end{itemize}
}

\frame{
\vspace{6em}
\begin{figure}
\Huge{Thank you for listening}
\end{figure}
\vspace{5em}
\centerline{\clash{} Clone URL:}
\centerline{\url{git://github.com/christiaanb/clash.git}}
}

\frame
{
\frametitle{Complete signatures and Types}
\begin{code}
type Word         =   SizedInt D12  
type Instruction  =   ( Opcode, Word, RangedWord D9
                      , RangedWord D9 )

registers :: 
  ( NaturalT s 
  , PositiveT (s :+: D1)
  , ((s :+: D1) :>: s) ~ True )) => 
  a -> RangedWord s -> RangedWord s -> 
  (RegState s a) -> 
  (RegState s a, a )
\end{code}
}

\frame
{
\frametitle{Supported Functionality}
\begin{itemize}
\item Polymorphism
\item Higher Order Functions
\item Fixed-Size Vectors (Simulation)
\item Ranged and Sized Integers (Simulation)
\item Custom Datatypes
\item Booleans, Tuples
\item Pattern Matching
\item Guards
\end{itemize}
}

\frame
{
\frametitle{Unsupported Functionality}
\begin{itemize}
\item Recursions
\item Lists (Dynamic Length)
\item Standard Haskell Types: Integer, Char, etc.
\item Monads
\item And much much more...
\end{itemize}
}
