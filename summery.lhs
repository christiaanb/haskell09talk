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

\frame{
\begin{figure}
\centerline{\includegraphics[width=12cm]{polyaluhardware}}
\label{img:mealymachine}
\end{figure}
}

\frame{
\begin{figure}
\centerline{\includegraphics[width=12cm]{polyaluhardware-reg}}
\label{img:mealymachine}
\end{figure}
}

\frame{
\begin{figure}
\centerline{\includegraphics[width=12cm]{polyaluhardware-add}}
\label{img:mealymachine}
\end{figure}
}
