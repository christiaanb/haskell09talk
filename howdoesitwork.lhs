%include talk.fmt
\section{How do you make Hardware from Haskell?}
\frame
{
  \frametitle{So how do you make Hardware from Haskell?}\pause
  \large{In three simple steps really:} \pause
  \begin{itemize}
    \item No Effort:\\
    GHC API Parses, Typechecks and Desugars the Haskell code \pause
    \item Hard: \\
    Transform resulting Core, GHC's Intermediate Language,\linebreak to a normal form. Uses reduction rules. \pause
    \item Easy: \\
    Translate Normalized Core to synthesizable VHDL
  \end{itemize}
}\note[itemize]{
\item Here is a quick insight as to how WE translate Haskell to Hardware
\item Normal form already looks like hardware (components and lines)
\item You can also use TH, like ForSyDe. Or traverse datastructures, like ?
\item We're in luck with the GHC API update of 6.10 and onwards
}
