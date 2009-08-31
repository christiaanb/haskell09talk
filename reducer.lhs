\section{Real Hardware Designs}
\frame{
\frametitle{More than just toys}
\pause
\begin{itemize}
  \item We designed a reduction circuit in \clash{}\pause
  \item Simulation results in Haskell match VHDL simulation results\pause
  \item Synthesis completes without errors or warnings\pause
  \item For the same Virtex-4 FPGA: \pause
    \begin{itemize}
      \item Hand coded VHDL design runs at 200 MHz\pause
      \item \clash{} design runs at around 85* MHz
    \end{itemize}
\end{itemize}
\vspace{6em}
\uncover<7->{\scriptsize{*Guestimate: design synthesized at 105 MHz, but with an Integer datapath instead of a floating point datapath.}}
}\note[itemize]{
\item Toys like the poly cpu one are good to give a quick demo
\item But we used \clash{} to design 'real' hardware
\item Reduction circuit sums the numbers in a row of a (sparse) matrix
\item Nice speed considering we don't optimize for it
}

\begin{frame}[plain] 
   \begin{centering} 
      \includegraphics[height=\paperheight]{reducerschematic.png} 
      \end{centering} 
\end{frame} 