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
    Transform resulting Core, GHC's Intermediate Language,\linebreak to a normal form \pause
    \item Easy: \\
    Translate Normalized Core to synthesizable VHDL
  \end{itemize}
}\note[itemize]{
\item Here is a quick insight as to how WE translate Haskell to Hardware
\item You can also use TH, like ForSyDe. Or traverse datastructures, like
\item We're in luck with the GHC API update of 6.10 and onwards
\item Normal form is a single lamda and a let expression, every let binder is a simple assignment
}