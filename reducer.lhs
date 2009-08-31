\section{Real Hardware Designs}
\frame{
\frametitle{More than just toys}
\pause
\begin{columns}[l]
\column{0.5\textwidth}
\begin{figure}
\includegraphics<2->[width=5.5cm]{reducer}
\end{figure}
\column{0.5\textwidth}
\begin{itemize}
  \item We implemented a reduction circuit in \clash{}\pause
  \item Simulation results in Haskell match VHDL simulation results\pause
  \item Synthesis completes without errors or warnings\pause
  \item Around half speed of handcoded and optimized VHDL
\end{itemize}
\end{columns}
}\note[itemize]{
\item Toys like the poly cpu one are good to give a quick demo
\item But we used \clash{} to design 'real' hardware
\item Reduction circuit sums the numbers in a row of a (sparse) matrix
\item Nice speed considering we don't optimize for it (only single example!)
}

% \begin{frame}[plain] 
%    \begin{centering} 
%       \includegraphics[height=\paperheight]{reducerschematic.png} 
%       \end{centering} 
% \end{frame} 
