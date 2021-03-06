\section{Demonstration}

\frame{
\frametitle{Demo}
\begin{itemize}
  \item Pre-Recored Video: VHDL Synthesis takes too long
  \item Simulate the CPU description
  \item Translate the CPU to VHDL
  \item Simulate the generated VHDL
\end{itemize}
}\note[itemize]{
\item Will show video
}

\frame{
\frametitle{Generated Schematic}
\begin{figure}
\centerline{\includegraphics<1>[width=10.3cm]{cpucomplete}
\includegraphics<2>[width=11.3cm]{cpualu}
\includegraphics<3>[height=6.3cm]{cpuregisters}}
\end{figure}
}

% 
% \frame{
% \frametitle{How do we use \clash{}?}
% As a library:
% \begin{itemize}
%   \item Import the module: CLasH.Translator
%   \item And call \emph{makeVHDLAnnotations ghc\_lib\_dir [files\_to\_translate]}
% \end{itemize}
% Customized GHC:
% \begin{itemize}
%   \item Call GHC with the --vhdl flag
%   \item Use the :vhdl command in GHCi
% \end{itemize}
% }
