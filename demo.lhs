\section{Demonstration}

\frame{
\frametitle{How do we use \clash{}?}
As a library:
\begin{itemize}
  \item Import the module: CLasH.Translator
  \item And call \emph{makeVHDLAnnotations ghc\_lib\_dir [files\_to\_translate]}
\end{itemize}
Use customized GHC:
\begin{itemize}
  \item Call GHC with the --vhdl flag
  \item Use the :vhdl command in GHCi
\end{itemize}
}

\frame{
\frametitle{Real Demo}
\begin{itemize}
  \item We will simulate the small CPU from earlier
  \item Translate the CPU code to VHDL
  \item Simulate the generated VHDL
  \item Synthesize the VHDL to get a hardware schematic
\end{itemize}
}