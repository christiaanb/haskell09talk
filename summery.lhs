%include talk.fmt
\section{Conclusion}

\frame{
\frametitle{Some final words}
\begin{itemize}
  \item Still a lot to do: make a bigger subset of Haskell translatable
  \item Real world designs work
  \item We bring functional expressivity to hardware designs
\end{itemize}
}

\frame{
\begin{figure}
\Huge{Thank you for listening}
\end{figure}
}

\frame
{
\frametitle{Complete signature for registerBank}
\begin{code}
registerBank :: 
  ( NaturalT s
  , PositiveT (s :+: D1)
  , ((s :+: D1) :>: s) ~ True )) =>
  (RegState s a) -> a -> RangedWord s ->
  RangedWord s -> Bit -> ((RegState s a), a )
\end{code}
}