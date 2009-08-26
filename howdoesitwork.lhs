%include talk.fmt
\section{How do you make Hardware from Haskell?}
\frame
{
  \frametitle{So how do you make Hardware from Haskell?}
  \large{In three simple steps} \pause
  \begin{itemize}
    \item No Effort:\\
    GHC API Parses, Typechecks and Desugars Haskell \pause
    \item Hard.. sort of: \\
    Transform resulting Core, GHC's Intermediate Language,\linebreak to a normal form \pause
    \item Easy: \\
    Translate Normalized Core to synthesizable VHDL
  \end{itemize}
}