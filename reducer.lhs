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
  \item Simulated in Haskell. VHDL simulation results match\pause
  \item Synthesis completes without errors or warnings\pause
  \item Around half speed of handcoded and optimized VHDL
\end{itemize}
\end{columns}
}\note[itemize]{
\item Toys like the poly cpu one are good to give a quick demo
\item But we used \clash{} to design 'real' hardware
\item Reduction circuit sums the numbers in a row, of different length
\item It uses a pipelined adder: multiple rows in pipeline, rows longer than pipeline
\item We hope you see this is not a trivial problem
\item Nice speed considering we don't optimize for it (only single example!)
}

% \begin{frame}[plain] 
%    \begin{centering} 
%       \includegraphics[height=\paperheight]{reducerschematic.png} 
%       \end{centering} 
% \end{frame} 
