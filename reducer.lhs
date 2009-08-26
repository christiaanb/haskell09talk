\section{Real Hardware Designs}
\frame{
\frametitle{More than just toys}
\pause
\begin{itemize}
  \item We designed a matrix reduction circuit\pause
  \item Simulation results in Haskell match VHDL simulation results\pause
  \item Synthesis completes without errors or warnings\pause
  \item It runs at half the speed of a hand-coded VHDL design
\end{itemize}
}\note[itemize]{
\item Toys like the poly cpu one are good to give a quick demo
\item But we used \clash{} to design 'real' hardware
\item Reduction circuit sums the numbers in a row of a (sparse) matrix
\item Half speed is nice, considering we don't optimize for speed
}