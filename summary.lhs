%include talk.fmt
\section{Conclusion}

\frame{
\frametitle{Some final words}
\begin{itemize}
  \item Still a lot to do: translate larger subset of Haskell
  \item Real world prototypes can be made in \clash{}
  \item \clash{} is another great example of how to bring functional expressivity to hardware designs
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
